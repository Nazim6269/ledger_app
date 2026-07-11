import 'package:ledger_app/database/app_database.dart';
import 'package:ledger_app/features/settlement/domain/entities/settlement_data.dart';
import 'package:ledger_app/features/settlement/domain/repositories/settlement_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class SettlementRepositoryImpl implements SettlementRepository {
  final AppDatabase _db;
  SettlementRepositoryImpl(this._db);

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
    await _db.insertSettlement(
      SettlementsCompanion.insert(
        id: uuid.v4(),
        householdId: householdId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        amount: amount,
      ),
    );
  }
}
