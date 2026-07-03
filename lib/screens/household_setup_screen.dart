import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/providers/household_repo_provider.dart';

class HouseholdSetupScreen extends ConsumerStatefulWidget {
  const HouseholdSetupScreen({super.key});

  @override
  ConsumerState<HouseholdSetupScreen> createState() =>
      _HouseholdSetupScreenState();
}

class _HouseholdSetupScreenState extends ConsumerState<HouseholdSetupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _createNameController = TextEditingController();
  final _joinCodeController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _create() async {
    if (_createNameController.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(householdRepoProvider)
          .createHouseHold(_createNameController.text.trim());
      ref.invalidate(
        currentHouseholdProvider,
      ); // triggers AuthGate-level refresh
    } catch (e) {
      setState(() => _error = 'Could not create household: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _join() async {
    if (_joinCodeController.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(householdRepoProvider)
          .joinHousehold(_joinCodeController.text.trim());
      ref.invalidate(currentHouseholdProvider);
    } catch (e) {
      setState(
        () => _error = 'Could not join household: check the invite code',
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Household'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Create New'),
            Tab(text: 'Join Existing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _createNameController,
                  decoration: const InputDecoration(
                    labelText: 'Household name (e.g. "Our Home")',
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loading ? null : _create,
                  child: const Text('Create Household'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _joinCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Paste invite code',
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loading ? null : _join,
                  child: const Text('Join Household'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: _error != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            )
          : null,
    );
  }
}

