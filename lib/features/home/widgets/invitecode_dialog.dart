import 'package:flutter/material.dart';

class InviteCodeDialog {
  static Future<void> show(BuildContext context, String code) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Invite Code"),
        content: SelectableText(code),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
