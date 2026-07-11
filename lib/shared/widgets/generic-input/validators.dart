/// A pure function: input value -> error message, or `null` if valid.
typedef FieldValidator = String? Function(String? value);

/// Reusable, composable validators.
///
/// Each static method returns a [FieldValidator] closure rather than
/// performing validation itself, which is what makes [combine] possible:
/// validators are just values that can be stored, passed around, and
/// chained, with zero coupling to any widget.
class Validators {
  const Validators._();

  static FieldValidator required([String message = 'This field is required']) {
    return (value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  static FieldValidator email([
    String message = 'Enter a valid email address',
  ]) {
    final regex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[\w\-]{2,}$');
    return (value) {
      if (value == null || value.isEmpty) return null;
      return regex.hasMatch(value) ? null : message;
    };
  }

  static FieldValidator phone([String message = 'Enter a valid phone number']) {
    final regex = RegExp(r'^\+?[\d\s\-()]{7,15}$');
    return (value) {
      if (value == null || value.isEmpty) return null;
      return regex.hasMatch(value) ? null : message;
    };
  }

  static FieldValidator password({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireNumber = true,
    bool requireSpecialChar = true,
    String? message,
  }) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < minLength) {
        return message ?? 'Password must be at least $minLength characters';
      }
      if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(value)) {
        return message ?? 'Password must contain an uppercase letter';
      }
      if (requireNumber && !RegExp(r'\d').hasMatch(value)) {
        return message ?? 'Password must contain a number';
      }
      if (requireSpecialChar &&
          !RegExp(r'[!@#\$&*~%^()_\-+=]').hasMatch(value)) {
        return message ?? 'Password must contain a special character';
      }
      return null;
    };
  }

  static FieldValidator amount({
    double? min,
    double? max,
    String message = 'Enter a valid amount',
  }) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final parsed = double.tryParse(value);
      if (parsed == null) return message;
      if (min != null && parsed < min) return 'Amount must be at least $min';
      if (max != null && parsed > max) return 'Amount must not exceed $max';
      return null;
    };
  }

  static FieldValidator date({String message = 'Enter a valid date'}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      return DateTime.tryParse(value) == null ? message : null;
    };
  }

  static FieldValidator min(num minValue, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final parsed = num.tryParse(value);
      if (parsed == null) return message ?? 'Enter a valid number';
      return parsed < minValue
          ? (message ?? 'Must be at least $minValue')
          : null;
    };
  }

  static FieldValidator max(num maxValue, {String? message}) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      final parsed = num.tryParse(value);
      if (parsed == null) return message ?? 'Enter a valid number';
      return parsed > maxValue
          ? (message ?? 'Must not exceed $maxValue')
          : null;
    };
  }

  static FieldValidator length({int? min, int? max, String? message}) {
    return (value) {
      final length = value?.length ?? 0;
      if (min != null && length < min) {
        return message ?? 'Must be at least $min characters';
      }
      if (max != null && length > max) {
        return message ?? 'Must not exceed $max characters';
      }
      return null;
    };
  }

  /// Validates that [value] matches another value, e.g. confirm-password.
  /// [other] is a getter so it always reads the latest value at validate
  /// time (important when wired to a separate controller).
  static FieldValidator match(
    String? Function() other, {
    String message = 'Values do not match',
  }) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      return value == other() ? null : message;
    };
  }

  static FieldValidator custom(FieldValidator validator) => validator;

  /// Combines multiple validators; returns the first non-null error.
  static FieldValidator combine(List<FieldValidator> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
