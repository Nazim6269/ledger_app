import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledger_app/core/widgets/app_card.dart';
import 'package:ledger_app/shared/widgets/generic-button/button.dart';
import 'package:ledger_app/shared/widgets/generic-input/generic_input.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_type.dart';

class JoinHouseholdTab extends StatelessWidget {
  const JoinHouseholdTab({
    super.key,
    required this.codeController,
    required this.isLoading,
    required this.onJoin,
  });

  final TextEditingController codeController;
  final bool isLoading;
  final VoidCallback onJoin;
  Future<void> _pasteCode() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null) {
      codeController.text = data!.text!.trim();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AppCard(
        icon: Icons.groups_2_rounded,
        title: 'Join a household',
        subtitle: 'Paste the invite code someone shared with you.',
        children: [
          GenericInput(
            controller: codeController,
            inputType: InputType.text,
            label: 'Invite code',
            prefixIcon: const Icon(Icons.qr_code_rounded),
            suffixIcon: IconButton(
              icon: const Icon(Icons.paste_rounded),
              tooltip: 'Paste from clipboard',
              onPressed: _pasteCode,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GenericButton(
              label: 'Join Household',
              isLoading: isLoading,
              onPressed: onJoin,
            ),
          ),
        ],
      ),
    );
  }
}
