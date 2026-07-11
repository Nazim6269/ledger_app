import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_decoration_builder.dart';
import 'input_theme.dart';
import 'input_type.dart';
import 'validators.dart';

typedef PickerTapCallback = Future<void> Function();

class GenericInput extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;

  final InputType inputType;

  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;

  final bool floatingLabel;
  final bool showCounter;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;

  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;
  final FieldValidator? validator;
  final AutovalidateMode autovalidateMode;

  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  /// Required for [InputType.date], [InputType.time],
  /// [InputType.dateTime] and [InputType.readonlyPicker]. Invoked
  /// instead of opening the keyboard when the field is tapped.
  final PickerTapCallback? onPickerTap;

  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextAlign textAlign;
  final TextStyle? style;
  final Color? cursorColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final Color? fillColor;
  final InputDecoration? decoration;

  /// Accessible label for screen readers; falls back to [label]/[hint].
  final String? semanticLabel;

  const GenericInput({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.inputType = InputType.text,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.floatingLabel = true,
    this.showCounter = true,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onSubmitted,
    this.onPickerTap,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.textAlign = TextAlign.start,
    this.style,
    this.cursorColor,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.decoration,
    this.semanticLabel,
  }) : assert(
         controller == null || initialValue == null,
         'Provide either a controller or an initialValue, not both.',
       );

  @override
  State<GenericInput> createState() => _GenericInputState();
}

class _GenericInputState extends State<GenericInput> {
  // Local UI-only state: password visibility. Nothing business-related
  // is ever stored here, keeping the widget safe to drop into Riverpod,
  // Bloc, Cubit, Provider, or plain MVVM screens without state conflicts.
  late bool _obscureText;
  TextEditingController? _internalController;

  bool get _isPasswordType =>
      widget.inputType == InputType.password ||
      widget.inputType == InputType.confirmPassword;

  TextEditingController get _controller =>
      widget.controller ??
      (_internalController ??= TextEditingController(
        text: widget.initialValue,
      ));

  @override
  void initState() {
    super.initState();
    final defaults = InputTypeResolver.resolve(widget.inputType);
    _obscureText = widget.obscureText || defaults.obscureText;
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  bool get _isPickerType =>
      widget.inputType == InputType.date ||
      widget.inputType == InputType.time ||
      widget.inputType == InputType.dateTime ||
      widget.inputType == InputType.readonlyPicker;

  @override
  Widget build(BuildContext context) {
    final theme = InputTheme.of(context);
    final defaults = InputTypeResolver.resolve(widget.inputType);

    final effectiveReadOnly = widget.readOnly || defaults.readOnly;
    final effectiveObscure = _isPasswordType
        ? _obscureText
        : widget.obscureText;
    final effectiveKeyboardType = widget.keyboardType ?? defaults.keyboardType;
    final effectiveCapitalization =
        widget.textCapitalization ?? defaults.capitalization;
    final effectiveTextInputAction =
        widget.textInputAction ?? defaults.textInputAction;
    final effectiveMaxLength = widget.maxLength ?? defaults.maxLength;
    final effectiveFormatters = <TextInputFormatter>[
      ...defaults.formatters,
      ...?widget.inputFormatters,
    ];

    final effectiveTheme =
        (widget.borderRadius != null || widget.fillColor != null)
        ? theme.copyWith(
            borderRadius: widget.borderRadius,
            fillColor: widget.fillColor,
          )
        : theme;

    final suffixIcon = _resolveSuffixIcon(context);

    final decoration = InputDecorationBuilder.build(
      context: context,
      theme: effectiveTheme,
      label: widget.label,
      hint: widget.hint,
      helperText: widget.helperText,
      errorText: widget.errorText,
      prefix: widget.prefix,
      suffix: widget.suffix,
      prefixIcon: widget.prefixIcon,
      suffixIcon: suffixIcon,
      maxLength: effectiveMaxLength,
      showCounter: widget.showCounter,
      enabled: widget.enabled,
      floatingLabel: widget.floatingLabel,
      contentPadding: widget.contentPadding,
      customDecoration: widget.decoration,
    );

    return Semantics(
      label: widget.semanticLabel ?? widget.label ?? widget.hint,
      textField: true,
      enabled: widget.enabled,
      child: TextFormField(
        controller: _controller,
        focusNode: widget.focusNode,
        keyboardType: effectiveKeyboardType,
        textInputAction: effectiveTextInputAction,
        textCapitalization: effectiveCapitalization,
        obscureText: effectiveObscure,
        readOnly: effectiveReadOnly || _isPickerType,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        maxLines: effectiveObscure ? 1 : (widget.maxLines ?? 1),
        minLines: widget.minLines,
        maxLength: effectiveMaxLength,
        inputFormatters: effectiveFormatters,
        validator: widget.validator,
        autovalidateMode: widget.autovalidateMode,
        textAlign: widget.textAlign,
        style: widget.style ?? effectiveTheme.inputStyle,
        cursorColor: widget.cursorColor,
        decoration: decoration,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onSubmitted,
        onTap: _isPickerType ? () => widget.onPickerTap?.call() : widget.onTap,
      ),
    );
  }

  Widget? _resolveSuffixIcon(BuildContext context) {
    if (widget.suffixIcon != null) return widget.suffixIcon;
    if (!_isPasswordType) return null;

    return IconButton(
      icon: Icon(
        _obscureText
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
      ),
      tooltip: _obscureText ? 'Show password' : 'Hide password',
      onPressed: () => setState(() => _obscureText = !_obscureText),
    );
  }
}
