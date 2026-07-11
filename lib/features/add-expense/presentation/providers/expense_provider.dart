import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/add-expense/data/repositories/expense_repository_impl.dart';
import 'package:ledger_app/features/add-expense/domain/repositories/expense_repository.dart';
import 'package:ledger_app/features/common/providers/database_provider.dart';

final expenseRepoProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.watch(databaseProvider));
});
