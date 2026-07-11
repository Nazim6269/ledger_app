import 'package:flutter/material.dart';
import 'package:ledger_app/shared/widgets/generic-input/input_theme.dart';

class InputDecorationBuilder {
  const InputDecorationBuilder._();

  static InputDecoration build({
    required BuildContext context,
    required InputTheme theme,
    String? label,
    String? hint,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Widget? prefix,
    Widget? suffix,
    int? maxLength,
    bool showCounter = true,
    bool enabled = true,
    bool floatingLabel = true,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? customDecoration,
  }) {
    if (customDecoration != null) return customDecoration;

    final radius = BorderRadius.circular(theme.borderRadius);

    OutlineInputBorder borderWith(Color color) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color),
    );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefix: prefix,
      suffix: suffix,
      counterText: showCounter ? null : '',
      filled: true,
      fillColor: enabled ? theme.fillColor : theme.disabledFillColor,
      contentPadding: contentPadding ?? theme.contentPadding,
      floatingLabelBehavior: floatingLabel
          ? FloatingLabelBehavior.auto
          : FloatingLabelBehavior.never,
      labelStyle: theme.labelStyle,
      hintStyle: theme.hintStyle,
      helperStyle: theme.helperStyle,
      errorStyle: theme.errorStyle,
      counterStyle: theme.counterStyle,
      border: borderWith(theme.borderColor),
      enabledBorder: borderWith(theme.borderColor),
      focusedBorder: borderWith(theme.focusedBorderColor),
      errorBorder: borderWith(theme.errorBorderColor),
      focusedErrorBorder: borderWith(theme.errorBorderColor),
      disabledBorder: borderWith(theme.disabledBorderColor),
    );
  }
}
