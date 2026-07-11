import 'package:flutter/material.dart';

import 'button_theme.dart';

extension ButtonThemeContextX on BuildContext {
  AppButtonTheme get appButtonTheme {
    final theme = Theme.of(this).extension<AppButtonTheme>();
    if (theme != null) return theme;
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? AppButtonTheme.dark()
        : AppButtonTheme.light();
  }
}
