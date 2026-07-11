import 'package:flutter/services.dart';

/// Formats digits as a phone number while typing, e.g. `(123) 456-7890`.
/// Pattern is configurable so it can adapt to different locales.
class PhoneFormatter extends TextInputFormatter {
  final String mask;

  /// `#` marks a digit slot, any other character is a literal separator.
  const PhoneFormatter({this.mask = '(###) ###-####'});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    var digitIndex = 0;

    for (final char in mask.characters) {
      if (digitIndex >= digits.length) break;
      if (char == '#') {
        buffer.write(digits[digitIndex]);
        digitIndex++;
      } else {
        buffer.write(char);
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// Formats a numeric string into a currency display, e.g. `1,234.56`.
class CurrencyFormatter extends TextInputFormatter {
  final String thousandsSeparator;
  final String decimalSeparator;
  final int decimalDigits;

  const CurrencyFormatter({
    this.thousandsSeparator = ',',
    this.decimalSeparator = '.',
    this.decimalDigits = 2,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    digits = digits.padLeft(decimalDigits + 1, '0');
    final wholePart = digits.substring(0, digits.length - decimalDigits);
    final decimalPart = digits.substring(digits.length - decimalDigits);

    final reversed = wholePart.split('').reversed.join();
    final grouped = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      grouped.add(reversed.substring(i, (i + 3).clamp(0, reversed.length)));
    }
    final formattedWhole = grouped
        .join(thousandsSeparator)
        .split('')
        .reversed
        .join();

    final result = decimalDigits > 0
        ? '$formattedWhole$decimalSeparator$decimalPart'
        : formattedWhole;

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

/// Groups digits for OTP display, e.g. `123 456`.
class OTPFormatter extends TextInputFormatter {
  final int length;
  final int groupSize;
  final String separator;

  const OTPFormatter({
    this.length = 6,
    this.groupSize = 3,
    this.separator = ' ',
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text
        .replaceAll(RegExp(r'\D'), '')
        .characters
        .take(length)
        .join();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % groupSize == 0) buffer.write(separator);
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// Formats a 16-digit card number into groups of 4, e.g. `4111 1111 1111 1111`.
class CardFormatter extends TextInputFormatter {
  const CardFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text
        .replaceAll(RegExp(r'\D'), '')
        .characters
        .take(19)
        .join();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class UpperCaseFormatter extends TextInputFormatter {
  const UpperCaseFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class LowerCaseFormatter extends TextInputFormatter {
  const LowerCaseFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}

/// Strips leading/trailing whitespace as the user types/pastes.
class TrimFormatter extends TextInputFormatter {
  const TrimFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final trimmed = newValue.text.trimLeft();
    return newValue.copyWith(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );
  }
}

/// Inserts thousands separators into a plain integer string, e.g. `12,345`.
class ThousandsSeparatorFormatter extends TextInputFormatter {
  final String separator;

  const ThousandsSeparatorFormatter({this.separator = ','});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final reversed = digits.split('').reversed.join();
    final grouped = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      grouped.add(reversed.substring(i, (i + 3).clamp(0, reversed.length)));
    }
    final result = grouped.join(separator).split('').reversed.join();

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}

/// Small extension used internally for safe character iteration without
/// pulling in the `characters` package as a hard dependency.
extension _StringCharacters on String {
  Iterable<String> get characters => split('');
}
