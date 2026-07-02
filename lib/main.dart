import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: LedgerApp()));
}

class LedgerApp extends StatelessWidget {
  const LedgerApp({super.key});

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      title: 'Ledger',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: HomeScreen(),
    );
  }
}

