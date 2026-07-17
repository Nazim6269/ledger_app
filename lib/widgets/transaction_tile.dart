import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ledger_app/core/theme/app_colors.dart';
import '../database/app_database.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.textColor});

  final Transaction transaction;
  final Color? textColor;

  static const _categoryIcons = <String, IconData>{
    'Groceries': Icons.shopping_cart_rounded,
    'Rent': Icons.home_rounded,
    'Utilities': Icons.bolt_rounded,
    'Dining': Icons.restaurant_rounded,
    'Transport': Icons.directions_car_rounded,
  };

  IconData get _icon =>
      _categoryIcons[transaction.category] ?? Icons.receipt_long_rounded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('MMM d, h:mm a');
    final color = textColor ?? theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.homeAccent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  _icon,
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                if (transaction.isShared)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.surfaceContainerHigh,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.people_rounded,
                        size: 8,
                        color: theme.colorScheme.onTertiary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.category,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.note.isNotEmpty
                      ? '${transaction.note} · ${formatter.format(transaction.createdAt)}'
                      : formatter.format(transaction.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${transaction.amount.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
