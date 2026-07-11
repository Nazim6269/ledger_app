import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ledger_app/features/home/screens/home_screen.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/household/screens/household_setup_screen.dart';
import 'package:ledger_app/features/auth/presentation/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: LedgerApp()));
}

class LedgerApp extends StatelessWidget {
  const LedgerApp({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'Ledger',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: AuthGate(),
    );
  }
}

//============ AuthGate ==================//
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        final session = state.session;
        if (session == null) return const LoginScreen();
        return HouseholdGate();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}

//============== HouseholdGate=================//
class HouseholdGate extends ConsumerWidget {
  HouseholdGate({super.key});

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
