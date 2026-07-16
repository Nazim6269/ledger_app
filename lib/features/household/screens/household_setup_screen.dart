import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledger_app/features/household/presentation/providers/household_provider.dart';
import 'package:ledger_app/features/household/widgets/create_household_tab.dart';

import '../../../core/widgets/error_banner.dart';
import '../widgets/join_household_tab.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Household'),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Create New'),
                  Tab(text: 'Join Existing'),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_error != null) ErrorBanner(message: _error!),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CreateHouseholdTab(
                  nameController: _createNameController,
                  isLoading: _loading,
                  onCreate: _create,
                ),
                JoinHouseholdTab(
                  codeController: _joinCodeController,
                  isLoading: _loading,
                  onJoin: _join,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //************** Helper *******************
  Future<void> _create() async {
    if (_createNameController.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(householdRepoProvider)
          .createHousehold(_createNameController.text.trim());
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
}
