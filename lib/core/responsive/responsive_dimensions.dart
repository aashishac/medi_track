import 'package:flutter/material.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';

class ResponsiveDimensions {
  ResponsiveDimensions._();
  // base reference width
  static final double _baseMobileWidth = 360;
  static final double _baseTabletWidth = 768;

  /// get scale factor based on screen width
  static double getScaleFactor(BuildContext context) {
    double screenWidth = MediaQuery.widthOf(context);
    double baseWidth = ResponsiveHelper.isMobile(context)
        ? _baseMobileWidth
        : _baseTabletWidth;
    double scaleFactor = screenWidth / baseWidth;

    // Different clamp ranges for different devices
    if (ResponsiveHelper.isMobile(context)) {
      return scaleFactor.clamp(0.85, 1.15);
    } else {
      return scaleFactor.clamp(0.9, 1.3);
    }
  }

  /// get responsive size for any dimension (padding, margin, width, height etc)
  static double getResponsiveSize(
    BuildContext context, {
    required double size,
  }) {
    return size * getScaleFactor(context);
  }

  /// Get responsive size based on screen width percentage
  static double getAdaptiveSize(
    BuildContext context, {
    required double percentage,
  }) {
    return MediaQuery.widthOf(context) * (percentage / 100);
  }

  /// Get device specific size
  static double getDeviceSpecificSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
  }) {
    return ResponsiveHelper.isMobile(context) ? mobile : tablet;
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

  static double spacing48(BuildContext context) =>
      getResponsiveSize(context, size: 48);

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

  static EdgeInsets paddingSymmetricAdaptive(
    BuildContext context, {
    double mobileHorizontal = 0,
    double tabletHorizontal = 0,
    double mobileVertical = 0,
    double tabletVertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: getDeviceSpecificSize(
        context,
        mobile: mobileHorizontal,
        tablet: tabletHorizontal,
      ),
      vertical: getDeviceSpecificSize(
        context,
        mobile: mobileVertical,
        tablet: tabletVertical,
      ),
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
