import 'package:flutter/material.dart';
import 'package:ledger_app/core/theme/app_colors.dart';
import 'package:ledger_app/core/theme/app_radius.dart';
import 'package:ledger_app/core/theme/app_spacing.dart';
import 'package:ledger_app/core/theme/app_typography.dart' show AppTypography;

@immutable
class InputTheme extends ThemeExtension<InputTheme> {
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;

  final Color fillColor;
  final Color disabledFillColor;

  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final Color disabledBorderColor;

  final TextStyle labelStyle;
  final TextStyle inputStyle;
  final TextStyle hintStyle;
  final TextStyle helperStyle;
  final TextStyle errorStyle;
  final TextStyle counterStyle;

  const InputTheme({
    this.borderRadius = AppRadius.field,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.fieldHorizontal,
      vertical: AppSpacing.fieldVertical,
    ),
    this.fillColor = AppColors.fill,
    this.disabledFillColor = AppColors.fillDisabled,
    this.borderColor = AppColors.border,
    this.focusedBorderColor = AppColors.borderFocused,
    this.errorBorderColor = AppColors.borderError,
    this.disabledBorderColor = AppColors.borderDisabled,
    this.labelStyle = AppTypography.label,
    this.inputStyle = AppTypography.input,
    this.hintStyle = AppTypography.hint,
    this.helperStyle = AppTypography.helper,
    this.errorStyle = AppTypography.error,
    this.counterStyle = AppTypography.counter,
  });

  factory InputTheme.of(BuildContext context) {
    return Theme.of(context).extension<InputTheme>() ?? const InputTheme();
  }

  @override
  InputTheme copyWith({
    double? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
    Color? disabledFillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    Color? disabledBorderColor,
    TextStyle? labelStyle,
    TextStyle? inputStyle,
    TextStyle? hintStyle,
    TextStyle? helperStyle,
    TextStyle? errorStyle,
    TextStyle? counterStyle,
  }) {
    return InputTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      fillColor: fillColor ?? this.fillColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      errorBorderColor: errorBorderColor ?? this.errorBorderColor,
      disabledBorderColor: disabledBorderColor ?? this.disabledBorderColor,
      labelStyle: labelStyle ?? this.labelStyle,
      inputStyle: inputStyle ?? this.inputStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      helperStyle: helperStyle ?? this.helperStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      counterStyle: counterStyle ?? this.counterStyle,
    );
  }

  @override
  InputTheme lerp(ThemeExtension<InputTheme>? other, double t) {
    if (other is! InputTheme) return this;
    return InputTheme(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t) ??
          contentPadding,
      fillColor: Color.lerp(fillColor, other.fillColor, t) ?? fillColor,
      disabledFillColor:
          Color.lerp(disabledFillColor, other.disabledFillColor, t) ??
          disabledFillColor,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      focusedBorderColor:
          Color.lerp(focusedBorderColor, other.focusedBorderColor, t) ??
          focusedBorderColor,
      errorBorderColor:
          Color.lerp(errorBorderColor, other.errorBorderColor, t) ??
          errorBorderColor,
      disabledBorderColor:
          Color.lerp(disabledBorderColor, other.disabledBorderColor, t) ??
          disabledBorderColor,
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t) ?? labelStyle,
      inputStyle: TextStyle.lerp(inputStyle, other.inputStyle, t) ?? inputStyle,
      hintStyle: TextStyle.lerp(hintStyle, other.hintStyle, t) ?? hintStyle,
      helperStyle:
          TextStyle.lerp(helperStyle, other.helperStyle, t) ?? helperStyle,
      errorStyle: TextStyle.lerp(errorStyle, other.errorStyle, t) ?? errorStyle,
      counterStyle:
          TextStyle.lerp(counterStyle, other.counterStyle, t) ?? counterStyle,
    );
  }

  static double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
