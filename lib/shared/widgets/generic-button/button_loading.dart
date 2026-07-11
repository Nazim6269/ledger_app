import 'package:flutter/material.dart';

class ButtonLoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;

  const ButtonLoadingIndicator({
    super.key,
    required this.size,
    required this.strokeWidth,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
