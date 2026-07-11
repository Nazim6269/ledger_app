import 'package:flutter/material.dart';

abstract class ButtonConstants {
  const ButtonConstants._();

  static const Duration animationDuration = Duration(milliseconds: 180);
  static const Curve animationCurve = Curves.easeOutCubic;
  static const Duration scaleDuration = Duration(milliseconds: 120);
  static const Curve scaleCurve = Curves.easeOut;
  static const double pressedScale = 0.97;
  static const double minTouchTargetSize = 48;
  static const double hoverOverlayOpacity = 0.08;
  static const double pressedOverlayOpacity = 0.12;
  static const double focusOverlayOpacity = 0.10;
  static const double rippleOpacity = 0.12;
}
