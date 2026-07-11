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

class Settlements extends Table {
  TextColumn get id => text()();
  TextColumn get householdId => text().references(Households, #id)();
  TextColumn get fromUserId => text()();
  TextColumn get toUserId => text()();
  RealColumn get amount => real()();
  DateTimeColumn get settledAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class OutboxItems extends Table {
  TextColumn get id => text()();
  TextColumn get tName => text()(); // 'transactions' | 'splits' | 'settlements'
  TextColumn get payload => text()(); // JSON-encoded row data
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

//====================DATABASE==================

@DriftDatabase(
  tables: [
    Households,
    HouseholdMembers,
    Transactions,
    Splits,
    Settlements,
    OutboxItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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

  Future<void> insertTransactionWithSplitCompanions({
    required TransactionsCompanion transaction,
    required List<SplitsCompanion> splits,
  }) async {
    await batch((batch) {
      batch.insert(transactions, transaction);
      batch.insertAll(this.splits, splits);
    });
  }

  Stream<List<Transaction>> watchSharedTransactions(String householdId) {
    return (select(transactions)..where(
          (t) => t.householdId.equals(householdId) & t.isShared.equals(true),
        ))
        .watch();
  }

  Stream<List<Split>> watchAllSplits() => select(splits).watch();

  Stream<List<Settlement>> watchSettlements(String householdId) {
    return (select(
      settlements,
    )..where((s) => s.householdId.equals(householdId))).watch();
  }

  Future<void> insertSettlement(SettlementsCompanion settlement) {
    return into(settlements).insert(settlement);
  }

  Future<void> upsertTransactionFromRemote(Map<String, dynamic> row) async {
    await into(transactions).insertOnConflictUpdate(
      TransactionsCompanion.insert(
        id: row['id'],
        householdId: row['household_id'],
        createdBy: row['created_by'],
        amount: (row['amount'] as num).toDouble(),
        category: row['category'],
        note: Value(row['note'] ?? ''),
        isShared: row['is_shared'],
        isSynced: const Value(true),
      ),
    );
  }

  Future<void> upsertSplitFromRemote(Map<String, dynamic> row) async {
    await into(splits).insertOnConflictUpdate(
      SplitsCompanion.insert(
        id: row['id'],
        transactionId: row['transaction_id'],
        userId: row['user_id'],
        amountOwed: (row['amount_owed'] as num).toDouble(),
      ),
    );
  }

  Future<void> upsertSettlementFromRemote(Map<String, dynamic> row) async {
    await into(settlements).insertOnConflictUpdate(
      SettlementsCompanion.insert(
        id: row['id'],
        householdId: row['household_id'],
        fromUserId: row['from_user_id'],
        toUserId: row['to_user_id'],
        amount: (row['amount'] as num).toDouble(),
      ),
    );
  }

  Future<void> addToOutbox(String id, String tableName, String jsonPayload) {
    return into(outboxItems).insert(
      OutboxItemsCompanion.insert(
        id: id,
        tName: tableName,
        payload: jsonPayload,
      ),
    );
  }

  Future<List<OutboxItem>> getOutboxItems() => select(outboxItems).get();

  Future<void> removeFromOutbox(String id) {
    return (delete(outboxItems)..where((o) => o.id.equals(id))).go();
  }

  Future<void> incrementRetryCount(String id) async {
    final item = await (select(
      outboxItems,
    )..where((o) => o.id.equals(id))).getSingle();
    await (update(outboxItems)..where((o) => o.id.equals(id))).write(
      OutboxItemsCompanion(retryCount: Value(item.retryCount + 1)),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ledger.sqlite'));
    return NativeDatabase(file);
  });
}
