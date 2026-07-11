import 'package:ledger_app/database/app_database.dart';

abstract class TransactionRepository {
  Future<List<HouseholdMember>> getMembers(String householdId);
  Future<void> saveExpense({
    required String householdId,
    required String createdBy,
    required double amount,
    required String category,
    required String note,
    required bool isShared,
    required Map<String, double> splits,
  });
  Future<void> processOutbox();
  void startRealtimeSync(String householdId);
}
