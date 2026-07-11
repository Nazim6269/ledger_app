import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ledger_app/features/common/providers/database_provider.dart';
import 'package:ledger_app/features/common/repositories/transaction_repositories.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(
    ref.watch(databaseProvider),
    ref.watch(supabaseClientProvider),
  );
});

