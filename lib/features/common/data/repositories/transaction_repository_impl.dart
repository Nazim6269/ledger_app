import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ledger_app/database/app_database.dart';
import 'package:ledger_app/features/common/data/services/outbox_service.dart';
import 'package:ledger_app/features/common/domain/repositories/transaction_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;
  final SupabaseClient _supabase;
  final OutboxService _outbox;

  TransactionRepositoryImpl(this._db, this._supabase)
      : _outbox = OutboxService(_db, _supabase);

  @override
  Future<List<HouseholdMember>> getMembers(String householdId) {
    return _db.getHouseholdMembers(householdId);
  }

  @override
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

    await _db.addToOutbox(
      uuid.v4(),
      'transactions',
      jsonEncode({
        'id': transactionId,
        'household_id': householdId,
        'created_by': createdBy,
        'amount': amount,
        'category': category,
        'note': note,
        'is_shared': isShared,
      }),
    );

    for (final s in splitRows) {
      await _db.addToOutbox(
        uuid.v4(),
        'splits',
        jsonEncode({
          'id': s.id.value,
          'transaction_id': s.transactionId.value,
          'user_id': s.userId.value,
          'amount_owed': s.amountOwed.value,
        }),
      );
    }

    unawaited(_outbox.processOutbox());
  }

  @override
  Future<void> processOutbox() => _outbox.processOutbox();

  @override
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
