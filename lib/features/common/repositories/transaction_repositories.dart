import 'package:drift/drift.dart';
import 'package:ledger_app/database/app_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TransactionRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;

  TransactionRepository(this._db, this._supabase);

  Future<List<HouseholdMember>> getMembers(String householdId) {
    return _db.getHouseholdMembers(householdId);
  }

  Future<void> saveExpense({
    required String householdId,
    required String createdBy,
    required double amount,
    required String category,
    required String note,
    required bool isShared,
    required Map<String, double> splits,
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
    await _pushToSupabase(transaction: transaction, splits: splitRows);
  }

  Future<void> _pushToSupabase({
    required TransactionsCompanion transaction,
    required List<SplitsCompanion> splits,
  }) async {
    await _supabase.from('transactions').insert({
      'id': transaction.id.value,
      'household_id': transaction.householdId.value,
      'created_by': transaction.createdBy.value,
      'amount': transaction.amount.value,
      'category': transaction.category.value,
      'note': transaction.note.value,
      'is_shared': transaction.isShared.value,
    });

    if (splits.isNotEmpty) {
      await _supabase.from('splits').insert(
            splits.map((s) => {
              'id': s.id.value,
              'transaction_id': s.transactionId.value,
              'user_id': s.userId.value,
              'amount_owed': s.amountOwed.value,
            }).toList(),
          );
    }
  }

  void startRealtimeSync(String householdId) {
    _supabase
        .channel('household_$householdId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'transactions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'household_id',
            value: householdId,
          ),
          callback: (payload) async {
            final row = payload.newRecord;
            await _db.upsertTransactionFromRemote(row);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'splits',
          callback: (payload) async {
            final row = payload.newRecord;
            await _db.upsertSplitFromRemote(row);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'settlements',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'household_id',
            value: householdId,
          ),
          callback: (payload) async {
            final row = payload.newRecord;
            await _db.upsertSettlementFromRemote(row);
          },
        )
        .subscribe();
  }
}
