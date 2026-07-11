import 'package:flutter/material.dart';
import 'package:ledger_app/core/theme/app_colors.dart';
import 'package:ledger_app/core/theme/app_spacing.dart';

/// Strength levels returned by [PasswordStrengthEvaluator].
enum PasswordStrength { weak, medium, strong }

/// Pure scoring function — no widget, no state, fully unit-testable.
class PasswordStrengthEvaluator {
  const PasswordStrengthEvaluator._();

  static PasswordStrength evaluate(String value) {
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[!@#\$&*~%^()_\-+=]').hasMatch(value)) score++;

    if (score <= 1) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
}

/// Optional, opt-in strength meter you place under an [AppTextField] of
/// type [InputType.password]. Kept as a SEPARATE widget rather than
/// being baked into [AppTextField] itself, so fields that don't need a
/// strength indicator (login forms, confirm-password) pay zero cost for
/// it — composition over inheritance / forced features.
class AppPasswordStrengthIndicator extends StatelessWidget {
  final String value;

  const AppPasswordStrengthIndicator({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    final strength = PasswordStrengthEvaluator.evaluate(value);
    final (color, label, filled) = switch (strength) {
      PasswordStrength.weak => (AppColors.strengthWeak, 'Weak', 1),
      PasswordStrength.medium => (AppColors.strengthMedium, 'Medium', 2),
      PasswordStrength.strong => (AppColors.strengthStrong, 'Strong', 3),
    };

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          for (var i = 0; i < 3; i++)
            Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.only(right: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: i < filled ? color : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
