import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledger_app/shared/widgets/generic-button/button.dart';

class InviteCodeDialog extends StatelessWidget {
  const InviteCodeDialog({super.key, required this.inviteCode});

  final String inviteCode;

  static Future<void> show(BuildContext context, String inviteCode) {
    return showDialog(
      context: context,
      builder: (_) => InviteCodeDialog(inviteCode: inviteCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Invite Code'),
      content: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SelectableText(
                inviteCode,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20),
              color: AppColors.homeAccent,
              tooltip: 'Copy',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: inviteCode));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invite code copied')),
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        GenericButton(onPressed: () => Navigator.pop(context), label: "Close"),
      ],
    );
  }
}
