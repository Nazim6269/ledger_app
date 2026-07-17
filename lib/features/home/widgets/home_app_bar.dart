import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/settlement/presentation/screens/settlement_screen.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Ledger'),
      actions: [
        IconButton(
          onPressed: () {
            final household = ref.read(currentHouseholdProvider).value;
            if (household != null) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Invite Code"),
                  content: SelectableText(household.id),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            }
          },
          icon: Icon(Icons.group_add),
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettlementScreen()),
          ),
          icon: Icon(Icons.balance),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => ref.read(authRepositoryProvider).signOut(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
