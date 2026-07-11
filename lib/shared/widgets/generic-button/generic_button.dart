import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'button_constants.dart';
import 'button_icon.dart';
import 'button_loading.dart';
import 'button_size.dart';
import 'button_state.dart';
import 'button_style.dart';
import 'button_variant.dart';
import 'button_width.dart';

class GenericButton extends StatefulWidget {
  final String label;
  final ButtonVariant variant;
  final ButtonSize size;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final bool selected;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Widget? leading;
  final Widget? trailing;
  final ButtonWidthMode widthMode;
  final double? customWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final double? elevation;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;
  final double? iconSize;
  final bool enableHapticFeedback;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;

  const GenericButton({
    super.key,
    required this.label,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.selected = false,
    this.leadingIcon,
    this.trailingIcon,
    this.leading,
    this.trailing,
    this.widthMode = ButtonWidthMode.wrapContent,
    this.customWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.gradient,
    this.elevation,
    this.boxShadow,
    this.padding,
    this.margin,
    this.textStyle,
    this.iconSize,
    this.enableHapticFeedback = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
         widthMode != ButtonWidthMode.custom || customWidth != null,
         'customWidth must be provided when widthMode is ButtonWidthMode.custom',
       );

  @override
  State<GenericButton> createState() => _GenericButtonState();
}

class _GenericButtonState extends State<GenericButton> {
  static const _resolver = ButtonStyleResolver();

  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _isInteractive => !widget.isLoading && widget.onPressed != null;

  ButtonInteractionState get _interactionState {
    if (!_isInteractive) return ButtonInteractionState.disabled;
    if (_pressed) return ButtonInteractionState.pressed;
    if (widget.selected) return ButtonInteractionState.selected;
    if (_hovered) return ButtonInteractionState.hovered;
    if (_focused) return ButtonInteractionState.focused;
    return ButtonInteractionState.normal;
  }

  void _handleTap() {
    if (!_isInteractive) return;
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onPressed!.call();
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolver.resolve(
      context: context,
      variant: widget.variant,
      size: widget.size,
      state: _interactionState,
      backgroundColor: widget.backgroundColor,
      foregroundColor: widget.foregroundColor,
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      borderRadius: widget.borderRadius,
      gradient: widget.gradient,
      elevation: widget.elevation,
      boxShadow: widget.boxShadow,
      padding: widget.padding,
      textStyle: widget.textStyle,
      iconSize: widget.iconSize,
    );

    final double? width = switch (widget.widthMode) {
      ButtonWidthMode.wrapContent => null,
      ButtonWidthMode.fullWidth => double.infinity,
      ButtonWidthMode.custom => widget.customWidth,
    };

    final Widget content = widget.isLoading
        ? Center(
            child: ButtonLoadingIndicator(
              size: style.loaderSize,
              strokeWidth: style.loaderStrokeWidth,
              color: style.foreground,
            ),
          )
        : _ButtonContent(
            text: widget.label,
            style: style,
            leading: widget.leading,
            leadingIcon: widget.leadingIcon,
            trailing: widget.trailing,
            trailingIcon: widget.trailingIcon,
          );

    final Widget button = Semantics(
      button: true,
      enabled: _isInteractive,
      selected: widget.selected,
      label: widget.semanticLabel ?? widget.label,
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleTap();
              return null;
            },
          ),
        },
        child: Focus(
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          onFocusChange: (focused) => setState(() => _focused = focused),
          child: MouseRegion(
            cursor: _isInteractive
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            onEnter: (_) {
              if (_isInteractive) setState(() => _hovered = true);
            },
            onExit: (_) => setState(() => _hovered = false),
            child: AnimatedScale(
              scale: _pressed && _isInteractive
                  ? ButtonConstants.pressedScale
                  : 1.0,
              duration: ButtonConstants.scaleDuration,
              curve: ButtonConstants.scaleCurve,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isInteractive ? _handleTap : null,
                  onLongPress: _isInteractive ? widget.onLongPress : null,
                  onHighlightChanged: (pressed) =>
                      setState(() => _pressed = pressed),
                  borderRadius: style.borderRadius,
                  splashColor: style.foreground.withOpacity(
                    ButtonConstants.rippleOpacity,
                  ),
                  highlightColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: ButtonConstants.animationDuration,
                    curve: ButtonConstants.animationCurve,
                    height: style.height,
                    width: width,
                    padding: style.padding,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: style.gradient == null ? style.background : null,
                      gradient: style.gradient,
                      borderRadius: style.borderRadius,
                      border: style.borderWidth > 0
                          ? Border.all(
                              color: style.borderColor,
                              width: style.borderWidth,
                            )
                          : null,
                      boxShadow:
                          style.boxShadow ??
                          (style.elevation > 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: style.elevation * 2,
                                    offset: Offset(0, style.elevation / 2),
                                  ),
                                ]
                              : null),
                    ),
                    child: content,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.margin != null) {
      return Padding(padding: widget.margin!, child: button);
    }
    return button;
  }
}

class _ButtonContent extends StatelessWidget {
  final String text;
  final ResolvedButtonStyle style;
  final Widget? leading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final IconData? trailingIcon;

  const _ButtonContent({
    required this.text,
    required this.style,
    required this.leading,
    required this.leadingIcon,
    required this.trailing,
    required this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    final leadingWidget =
        leading ??
        (leadingIcon != null
            ? ButtonIconView(
                icon: leadingIcon!,
                size: style.iconSize,
                color: style.foreground,
              )
            : null);
    if (leadingWidget != null) {
      children.add(leadingWidget);
      children.add(SizedBox(width: style.iconSpacing));
    }

    children.add(
      Flexible(
        child: Text(
          text,
          style: style.textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );

    final trailingWidget =
        trailing ??
        (trailingIcon != null
            ? ButtonIconView(
                icon: trailingIcon!,
                size: style.iconSize,
                color: style.foreground,
              )
            : null);
    if (trailingWidget != null) {
      children.add(SizedBox(width: style.iconSpacing));
      children.add(trailingWidget);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
