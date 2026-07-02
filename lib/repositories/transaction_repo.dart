import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class TransactionRepository {
  final AppDatabase _db;
  TransactionRepository(this._db);

  Future<List<HouseholdMember>> getMembers(String householdId) {
    return _db.getHouseholdMembers(householdId);
  }

  Stream<List<Transaction>> watchTransactions(String householdId) {
    return _db.watchTransactions(householdId);
  }

  Future<void> saveExpense({
    required String householdId,
    required String createdBy,
    required double amount,
    required String category,
    required String note,
    required bool isShared,
    required Map<String, double> splits, // userId -> amountOwed
  }) async {
    const uuid = Uuid();
    final transactionId = uuid.v4();

    final transaction = TransactionsCompanion.insert(
      id: transactionId,
      householdId: householdId,
      createdBy: createdBy,
      amount: amount,
      category: category,
      note: Value(note),
      isShared: Value(isShared),
    );

    final splitRows = splits.entries
        .map(
          (e) => SplitsCompanion.insert(
            id: uuid.v4(),
            transactionId: transactionId,
            userId: e.key,
            amountOwed: e.value,
          ),
        )
        .toList();

    await _db.insertTransactionWithSplitCompanions(
      transaction: transaction,
      splits: splitRows,
    );
  }
}
