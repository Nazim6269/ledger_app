import 'package:ledger_app/features/household/domain/entities/household.dart';

abstract class HouseholdRepository {
  Future<Household?> getMyHousehold();
  Future<Household> createHousehold(String name);
  Future<Household> joinHousehold(String householdId);
}
