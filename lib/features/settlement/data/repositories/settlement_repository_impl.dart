import 'dart:async';
import 'dart:convert';

import 'package:ledger_app/database/app_database.dart';
import 'package:ledger_app/features/common/data/services/outbox_service.dart';
import 'package:ledger_app/features/settlement/domain/entities/settlement_data.dart';
import 'package:ledger_app/features/settlement/domain/repositories/settlement_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SettlementRepositoryImpl implements SettlementRepository {
  final AppDatabase _db;
  final OutboxService _outbox;
  SettlementRepositoryImpl(this._db, SupabaseClient supabaseClient)
      : _outbox = OutboxService(_db, supabaseClient);

  @override
  Stream<SettlementData> watchSettlementData(String householdId) {
    return Rx.combineLatest3(
      _db.watchSharedTransactions(householdId),
      _db.watchAllSplits(),
      _db.watchSettlements(householdId),
      (transactions, splits, settlements) =>
          SettlementData(transactions, splits, settlements),
    );
  }

  @override
  Future<void> settleUp({
    required String fromUserId,
    required String toUserId,
    required String householdId,
    required double amount,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();
    await _db.insertSettlement(
      SettlementsCompanion.insert(
        id: id,
        householdId: householdId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        amount: amount,
      ),
    );

    await _db.addToOutbox(
      uuid.v4(),
      'settlements',
      jsonEncode({
        'id': id,
        'household_id': householdId,
        'from_user_id': fromUserId,
        'to_user_id': toUserId,
        'amount': amount,
      }),
    );

    unawaited(_outbox.processOutbox());
  }
}
