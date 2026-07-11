enum ButtonVariant {
  primary,
  subtle,
  secondary,
  outline,
  ghost,
  text,
  gradient,
  danger,
  success,
  warning,
}

extension ButtonVariantX on ButtonVariant {
  bool get isFilled => switch (this) {
    ButtonVariant.primary ||
    ButtonVariant.subtle ||
    ButtonVariant.secondary ||
    ButtonVariant.gradient ||
    ButtonVariant.danger ||
    ButtonVariant.success ||
    ButtonVariant.warning => true,
    ButtonVariant.outline || ButtonVariant.ghost || ButtonVariant.text => false,
  };

  bool get isSemantic =>
      this == ButtonVariant.danger ||
      this == ButtonVariant.success ||
      this == ButtonVariant.warning;
}
