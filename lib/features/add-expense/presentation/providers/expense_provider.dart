import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ledger_app/features/common/providers/database_provider.dart';
import 'package:ledger_app/features/common/data/repositories/transaction_repository_impl.dart';
import 'package:ledger_app/features/common/domain/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(supabaseClientProvider),
  );
});

