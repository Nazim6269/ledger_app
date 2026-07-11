import 'package:ledger_app/features/settlement/domain/entities/settlement_data.dart';

abstract class SettlementRepository {
  Stream<SettlementData> watchSettlementData(String householdId);
  Future<void> settleUp({
    required String fromUserId,
    required String toUserId,
    required String householdId,
    required double amount,
  });
}
