import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/home/screens/home_screen.dart';
import 'package:ledger_app/features/household/presentation/screens/household_setup_screen.dart';

class HouseholdGate extends ConsumerWidget {
  const HouseholdGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final householdAsync = ref.watch(currentHouseholdProvider);
    return householdAsync.when(
      data: (household) {
        return household != null
            ? const HomeScreen()
            : const HouseholdSetupScreen();
      },
      error: (error, _) => Scaffold(body: Center(child: Text("Error $error"))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
