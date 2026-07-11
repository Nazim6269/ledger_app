import 'package:flutter/services.dart';

enum InputType {
  text,
  multiline,
  number,
  decimal,
  phone,
  email,
  password,
  confirmPassword,
  search,
  username,
  url,
  amount,
  otp,
  pin,
  date,
  time,
  dateTime,
  readonlyPicker,
  custom,
}

class InputTypeDefaults {
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool isPassword;
  final TextCapitalization capitalization;
  final List<TextInputFormatter> formatters;
  final TextInputAction? textInputAction;
  final int? maxLength;

  const InputTypeDefaults({
    required this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.isPassword = false,
    this.capitalization = TextCapitalization.none,
    this.formatters = const [],
    this.textInputAction,
    this.maxLength,
  });
}

class InputTypeResolver {
  const InputTypeResolver._();

  static InputTypeDefaults resolve(InputType type) {
    switch (type) {
      case InputType.text:
        return const InputTypeDefaults(keyboardType: TextInputType.text);

      case InputType.multiline:
        return const InputTypeDefaults(
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        );

      case InputType.number:
        return InputTypeDefaults(
          keyboardType: const TextInputType.numberWithOptions(),
          formatters: [FilteringTextInputFormatter.digitsOnly],
        );

      case InputType.decimal:
        return InputTypeDefaults(
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
        );

      case InputType.phone:
        return InputTypeDefaults(
          keyboardType: TextInputType.phone,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s()]')),
          ],
        );

      case InputType.email:
        return const InputTypeDefaults(
          keyboardType: TextInputType.emailAddress,
          capitalization: TextCapitalization.none,
        );

      case InputType.password:
      case InputType.confirmPassword:
        return const InputTypeDefaults(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          isPassword: true,
        );

      case InputType.search:
        return const InputTypeDefaults(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

      case InputType.username:
        return InputTypeDefaults(
          keyboardType: TextInputType.text,
          capitalization: TextCapitalization.none,
          formatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
        );

      case InputType.url:
        return const InputTypeDefaults(
          keyboardType: TextInputType.url,
          capitalization: TextCapitalization.none,
        );

      case InputType.amount:
        return InputTypeDefaults(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
        );

      case InputType.otp:
        return InputTypeDefaults(
          keyboardType: TextInputType.number,
          formatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.done,
          maxLength: 6,
        );

      case InputType.pin:
        return InputTypeDefaults(
          keyboardType: TextInputType.number,
          obscureText: true,
          formatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 4,
        );

      case InputType.date:
      case InputType.time:
      case InputType.dateTime:
      case InputType.readonlyPicker:
        return const InputTypeDefaults(
          keyboardType: TextInputType.text,
          readOnly: true,
        );

      case InputType.custom:
        // Caller supplies everything (formatters/keyboardType/validator);
        // the resolver intentionally stays neutral.
        return const InputTypeDefaults(keyboardType: TextInputType.text);
    }
  }
}
