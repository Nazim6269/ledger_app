import 'package:flutter/material.dart';

import 'button_constants.dart';
import 'button_extensions.dart';
import 'button_size.dart';
import 'button_state.dart';
import 'button_variant.dart';

@immutable
class ResolvedButtonStyle {
  final Color background;
  final Color foreground;
  final Color borderColor;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Gradient? gradient;
  final double elevation;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final double iconSize;
  final double iconSpacing;
  final double loaderSize;
  final double loaderStrokeWidth;
  final double height;

  const ResolvedButtonStyle({
    required this.background,
    required this.foreground,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.gradient,
    required this.elevation,
    required this.boxShadow,
    required this.padding,
    required this.textStyle,
    required this.iconSize,
    required this.iconSpacing,
    required this.loaderSize,
    required this.loaderStrokeWidth,
    required this.height,
  });
}

class ButtonStyleResolver {
  const ButtonStyleResolver();

  ResolvedButtonStyle resolve({
    required BuildContext context,
    required ButtonVariant variant,
    required ButtonSize size,
    required ButtonInteractionState state,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    Gradient? gradient,
    double? elevation,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    double? iconSize,
  }) {
    final theme = context.appButtonTheme;
    final sizeConfig = size.config;
    final variantColors = theme.variants[variant]!;
    final disabled = state == ButtonInteractionState.disabled;

    final baseBackground = backgroundColor ?? variantColors.background;
    final baseForeground = foregroundColor ?? variantColors.foreground;
    final baseBorder = borderColor ?? variantColors.border;

    final resolvedBackground = disabled
        ? theme.disabledBackground
        : _withStateOverlay(baseBackground, state);
    final resolvedForeground = disabled
        ? theme.disabledForeground
        : baseForeground;
    final resolvedBorder = disabled ? theme.disabledBorder : baseBorder;

    final resolvedGradient = disabled
        ? null
        : (gradient ?? variantColors.gradient);

    final resolvedElevation = disabled
        ? theme.disabledElevation
        : elevation ??
              (state == ButtonInteractionState.pressed
                  ? theme.pressedElevation
                  : theme.elevation);

    return ResolvedButtonStyle(
      background: resolvedBackground,
      foreground: resolvedForeground,
      borderColor: resolvedBorder,
      borderWidth: borderWidth ?? theme.borderWidth,
      borderRadius: borderRadius ?? sizeConfig.borderRadius,
      gradient: resolvedGradient,
      elevation: resolvedElevation,
      boxShadow: disabled ? null : boxShadow,
      padding: padding ?? sizeConfig.padding,
      textStyle:
          (textStyle ??
                  TextStyle(
                    fontSize: sizeConfig.fontSize,
                    fontWeight: FontWeight.w600,
                  ))
              .copyWith(color: resolvedForeground),
      iconSize: iconSize ?? sizeConfig.iconSize,
      iconSpacing: sizeConfig.iconSpacing,
      loaderSize: sizeConfig.loaderSize,
      loaderStrokeWidth: sizeConfig.loaderStrokeWidth,
      height: sizeConfig.height,
    );
  }

  Color _withStateOverlay(Color base, ButtonInteractionState state) {
    final overlayOpacity = switch (state) {
      ButtonInteractionState.pressed => ButtonConstants.pressedOverlayOpacity,
      ButtonInteractionState.hovered => ButtonConstants.hoverOverlayOpacity,
      ButtonInteractionState.focused => ButtonConstants.focusOverlayOpacity,
      _ => 0.0,
    };
    if (overlayOpacity == 0.0) return base;
    final overlayColor = base.computeLuminance() > 0.5
        ? Colors.black.withOpacity(overlayOpacity)
        : Colors.white.withOpacity(overlayOpacity);
    return Color.alphaBlend(overlayColor, base);
  }
}
