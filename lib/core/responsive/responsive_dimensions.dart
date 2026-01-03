import 'package:flutter/material.dart';

class ResponsiveDimensions {
  ResponsiveDimensions._();
  // base reference width
  static final _baseWidth = 360;

  /// get scale factor based on screen width
  static double getScaleFactor(BuildContext context) {
    double screenWidth = MediaQuery.widthOf(context);
    double scaleFactor = screenWidth / _baseWidth;
    return scaleFactor.clamp(0.85, 1.15);
  }

  /// get responsive size for any dimension (padding, margin, width, height etc)
  static double getResponsiveSize(
    BuildContext context, {
    required double size,
  }) {
    return size * getScaleFactor(context);
  }

  // spacing
  static double spacing4(BuildContext context) =>
      getResponsiveSize(context, size: 4);
  static double spacing8(BuildContext context) =>
      getResponsiveSize(context, size: 8);

  static double spacing12(BuildContext context) =>
      getResponsiveSize(context, size: 12);

  static double spacing16(BuildContext context) =>
      getResponsiveSize(context, size: 16);

  /// Default size : 20 but size can be passed as parameter
  static double spacing20(BuildContext context, {double size = 20}) =>
      getResponsiveSize(context, size: size);

  // =================== padding =====================
  static EdgeInsets paddingAll4(BuildContext context) =>
      EdgeInsets.all(spacing4(context));

  static EdgeInsets paddingAll8(BuildContext context) =>
      EdgeInsets.all(spacing8(context));

  static EdgeInsets paddingAll12(BuildContext context) =>
      EdgeInsets.all(spacing12(context));

  static EdgeInsets paddingAll16(BuildContext context) =>
      EdgeInsets.all(spacing16(context));

  // horizontal padding
  static EdgeInsets paddingH4(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: spacing4(context));
  static EdgeInsets paddingH8(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: spacing8(context));
  static EdgeInsets paddingH12(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: spacing12(context));
  static EdgeInsets paddingH20(BuildContext context, {double size = 20}) =>
      EdgeInsets.symmetric(horizontal: spacing20(context, size: size));

  // symmetric padding
  static EdgeInsets paddingSymmetric(
    BuildContext context, {
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      vertical: getResponsiveSize(context, size: vertical),
      horizontal: getResponsiveSize(context, size: horizontal),
    );
  }

  static EdgeInsets paddingOnly(
    BuildContext context, {
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: getResponsiveSize(context, size: left),
      right: getResponsiveSize(context, size: right),
      top: getResponsiveSize(context, size: top),
      bottom: getResponsiveSize(context, size: bottom),
    );
  }
}
