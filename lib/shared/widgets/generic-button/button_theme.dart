import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'button_variant.dart';

@immutable
class ButtonVariantColors {
  final Color background;
  final Color foreground;
  final Color border;
  final Gradient? gradient;

  const ButtonVariantColors({
    required this.background,
    required this.foreground,
    required this.border,
    this.gradient,
  });

  ButtonVariantColors copyWith({
    Color? background,
    Color? foreground,
    Color? border,
    Gradient? gradient,
  }) {
    return ButtonVariantColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      border: border ?? this.border,
      gradient: gradient ?? this.gradient,
    );
  }

  static ButtonVariantColors lerp(
    ButtonVariantColors a,
    ButtonVariantColors b,
    double t,
  ) {
    return ButtonVariantColors(
      background: Color.lerp(a.background, b.background, t)!,
      foreground: Color.lerp(a.foreground, b.foreground, t)!,
      border: Color.lerp(a.border, b.border, t)!,
      gradient: t < 0.5 ? a.gradient : b.gradient,
    );
  }
}

@immutable
class AppButtonTheme extends ThemeExtension<AppButtonTheme> {
  final Map<ButtonVariant, ButtonVariantColors> variants;

  final Color disabledBackground;
  final Color disabledForeground;
  final Color disabledBorder;

  final double elevation;
  final double pressedElevation;
  final double disabledElevation;

  final double borderWidth;

  const AppButtonTheme({
    required this.variants,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.disabledBorder,
    this.elevation = 0,
    this.pressedElevation = 0,
    this.disabledElevation = 0,
    this.borderWidth = 1.4,
  });

  /// Default light-mode theme, built entirely from [AppColors].
  factory AppButtonTheme.light() {
    return AppButtonTheme(
      variants: {
        ButtonVariant.primary: const ButtonVariantColors(
          background: AppColors.homeAccent,
          foreground: Colors.white,
          border: Colors.transparent,
        ),
        ButtonVariant.secondary: const ButtonVariantColors(
          background: AppColors.secondary,
          foreground: AppColors.primary,
          border: Colors.transparent,
        ),
        ButtonVariant.subtle: const ButtonVariantColors(
          background: AppColors.secondary,
          foreground: AppColors.secondaryDark,
          border: Colors.transparent,
        ),
        ButtonVariant.outline: const ButtonVariantColors(
          background: Colors.transparent,
          foreground: AppColors.primary,
          border: AppColors.primary,
        ),
        ButtonVariant.ghost: const ButtonVariantColors(
          background: Colors.transparent,
          foreground: AppColors.onSurfaceLight,
          border: Colors.transparent,
        ),
        ButtonVariant.text: const ButtonVariantColors(
          background: Colors.transparent,
          foreground: AppColors.primary,
          border: Colors.transparent,
        ),
        ButtonVariant.gradient: const ButtonVariantColors(
          background: AppColors.primary,
          foreground: Colors.white,
          border: Colors.transparent,
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      },
      disabledBackground: AppColors.disabledSurfaceLight,
      disabledForeground: AppColors.disabledOnSurfaceLight,
      disabledBorder: AppColors.disabledSurfaceLight,
      elevation: 0,
      pressedElevation: 0,
      disabledElevation: 0,
    );
  }

  /// Default dark-mode theme.
  factory AppButtonTheme.dark() {
    return AppButtonTheme(
      variants: {
        ButtonVariant.primary: const ButtonVariantColors(
          background: AppColors.primaryDark,
          foreground: Colors.black,
          border: Colors.transparent,
        ),
        ButtonVariant.secondary: const ButtonVariantColors(
          background: AppColors.secondaryDark,
          foreground: AppColors.primaryDark,
          border: Colors.transparent,
        ),
        ButtonVariant.outline: const ButtonVariantColors(
          background: Colors.transparent,
          foreground: AppColors.primaryDark,
          border: AppColors.primaryDark,
        ),
        ButtonVariant.ghost: const ButtonVariantColors(
          background: Colors.transparent,
          foreground: AppColors.onSurfaceDark,
          border: Colors.transparent,
        ),
        ButtonVariant.text: const ButtonVariantColors(
          background: Colors.transparent,
          foreground: AppColors.primaryDark,
          border: Colors.transparent,
        ),
        ButtonVariant.gradient: const ButtonVariantColors(
          background: AppColors.primaryDark,
          foreground: Colors.black,
          border: Colors.transparent,
          gradient: LinearGradient(
            colors: [AppColors.primaryDark, Color(0xFFB388FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        ButtonVariant.danger: const ButtonVariantColors(
          background: AppColors.danger,
          foreground: Colors.white,
          border: Colors.transparent,
        ),
        ButtonVariant.success: const ButtonVariantColors(
          background: AppColors.success,
          foreground: Colors.white,
          border: Colors.transparent,
        ),
        ButtonVariant.warning: const ButtonVariantColors(
          background: AppColors.warning,
          foreground: Colors.black,
          border: Colors.transparent,
        ),
      },
      disabledBackground: AppColors.disabledSurfaceDark,
      disabledForeground: AppColors.disabledOnSurfaceDark,
      disabledBorder: AppColors.disabledSurfaceDark,
      elevation: 0,
      pressedElevation: 0,
      disabledElevation: 0,
    );
  }

  @override
  AppButtonTheme copyWith({
    Map<ButtonVariant, ButtonVariantColors>? variants,
    Color? disabledBackground,
    Color? disabledForeground,
    Color? disabledBorder,
    double? elevation,
    double? pressedElevation,
    double? disabledElevation,
    double? borderWidth,
  }) {
    return AppButtonTheme(
      variants: variants ?? this.variants,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      disabledForeground: disabledForeground ?? this.disabledForeground,
      disabledBorder: disabledBorder ?? this.disabledBorder,
      elevation: elevation ?? this.elevation,
      pressedElevation: pressedElevation ?? this.pressedElevation,
      disabledElevation: disabledElevation ?? this.disabledElevation,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  AppButtonTheme lerp(ThemeExtension<AppButtonTheme>? other, double t) {
    if (other is! AppButtonTheme) return this;
    final mergedVariants = <ButtonVariant, ButtonVariantColors>{};
    for (final key in variants.keys) {
      final a = variants[key];
      final b = other.variants[key];
      if (a != null && b != null) {
        mergedVariants[key] = ButtonVariantColors.lerp(a, b, t);
      } else {
        mergedVariants[key] = a ?? b!;
      }
    }
    return AppButtonTheme(
      variants: mergedVariants,
      disabledBackground: Color.lerp(
        disabledBackground,
        other.disabledBackground,
        t,
      )!,
      disabledForeground: Color.lerp(
        disabledForeground,
        other.disabledForeground,
        t,
      )!,
      disabledBorder: Color.lerp(disabledBorder, other.disabledBorder, t)!,
      elevation: _lerpDouble(elevation, other.elevation, t),
      pressedElevation: _lerpDouble(
        pressedElevation,
        other.pressedElevation,
        t,
      ),
      disabledElevation: _lerpDouble(
        disabledElevation,
        other.disabledElevation,
        t,
      ),
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
