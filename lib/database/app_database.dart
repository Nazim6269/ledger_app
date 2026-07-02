import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'app_database.g.dart';

class Households extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class HouseholdMembers extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text().references(Households, #id)();
  TextColumn get userId => text()();
  TextColumn get userName => text()();
  DateTimeColumn get joinedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text().references(Households, #id)();
  TextColumn get createdBy => text()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get isShared => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Splits extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text().references(Transactions, #id)();
  TextColumn get userId => text()();
  RealColumn get amountOwed => real()();

  @override
  Set<Column> get primaryKey => {id};
}

// ---- DATABASE ----

@DriftDatabase(tables: [Households, HouseholdMembers, Transactions, Splits])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //=========== SEED DATA=============//
  Future<void> seedIfEmpty() async {
    final existing = await select(households).get();
    if (existing.isNotEmpty) return;

    const householdId = 'house_1';
    await into(households).insert(
      HouseholdsCompanion.insert(
        id: householdId,
        name: 'Our Home',
        createdBy: 'user_1',
      ),
    );

    await into(householdMembers).insert(
      HouseholdMembersCompanion.insert(
        id: 'member_1',
        householdId: householdId,
        userId: 'user_1',
        userName: 'You',
      ),
    );

    await into(householdMembers).insert(
      HouseholdMembersCompanion.insert(
        id: 'member_2',
        householdId: householdId,
        userId: 'user_2',
        userName: 'Partner',
      ),
    );
  }

  //================ QUERIES==========================//
  Future<List<HouseholdMember>> getHouseholdMembers(String householdId) {
    return (select(
      householdMembers,
    )..where((m) => m.householdId.equals(householdId))).get();
  }

  Stream<List<Transaction>> watchTransactions(String householdId) {
    return (select(transactions)
          ..where((t) => t.householdId.equals(householdId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> insertTransactionWithSplits({
    required Transaction transaction,
    required List<Split> splits,
  }) async {
    await batch((batch) {
      batch.insert(transactions, transaction);
      batch.insertAll(this.splits, splits);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ledger.sqlite'));
    return NativeDatabase(file);
  });
}

