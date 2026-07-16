import 'package:flutter/material.dart';
import 'package:ledger_app/core/widgets/app_card.dart';
import 'package:ledger_app/shared/widgets/generic-button/button.dart';
import 'package:ledger_app/shared/widgets/generic-input/generic_input.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_type.dart';

class CreateHouseholdTab extends StatelessWidget {
  const CreateHouseholdTab({
    super.key,
    required this.nameController,
    required this.isLoading,
    required this.onCreate,
  });

  final TextEditingController nameController;
  final bool isLoading;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        icon: Icons.home_rounded,
        title: 'Start a household',
        subtitle: 'Give it a name your family or roommates will recognize.',
        children: [
          GenericInput(
            controller: nameController,
            inputType: InputType.text,
            label: 'Household name',
            hint: 'e.g. Our Home',
            prefixIcon: const Icon(Icons.home_outlined),
            fillColor: Theme.of(context).colorScheme.surface,
            borderRadius: 14,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GenericButton(
              label: 'Create Household',
              isLoading: isLoading,
              onPressed: onCreate,
            ),
          ),
        ],
      ),
    );
  }
}
