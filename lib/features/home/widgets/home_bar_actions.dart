import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/add-expense/presentation/providers/expense_provider.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ledger_app/features/home/widgets/invitecode_dialog.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/settlement/screens/settlement_screen.dart';

class HomeAppBarActions extends ConsumerWidget {
  const HomeAppBarActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.group_add_rounded),
          tooltip: 'Invite',
          onPressed: () {
            final household = ref.read(currentHouseholdProvider).value;
            if (household != null) {
              InviteCodeDialog.show(context, household.id);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.balance_rounded),
          tooltip: 'Settlement',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettlementScreen()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          tooltip: 'Log out',
          onPressed: () async {
            ref.read(transactionRepositoryProvider).stopRealtimeSync();
            await ref.read(authRepositoryProvider).signOut();
          },
        ),
      ],
    );
  }
}
