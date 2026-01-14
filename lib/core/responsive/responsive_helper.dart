// device type enum for identifying device categories
import 'package:flutter/widgets.dart';

enum DeviceType { mobile, tablet }

/// screen size breakpoints
class Breakpoints {
  Breakpoints._();
  static const double mobile = 600;
  static const double tablet = 1024;
}

/// Responsive helper class for adaptive UI design
class ResponsiveHelper {
  ResponsiveHelper._();

  /// Get current device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.widthOf(context);

    if (width < Breakpoints.mobile) {
      return .mobile;
    } else {
      return .tablet;
    }
  }

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == .mobile;

  /// Check if current device is table
  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == .tablet;

  /// Get responsive value based on device type
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    required T tablet,
  }) {
    return isMobile(context) ? mobile : tablet;
  }

  /// Get orientation
  static Orientation getOrientation(BuildContext context) =>
      MediaQuery.orientationOf(context);

  /// Check if device is in landscape mode
  static bool isLandScape(BuildContext context) {
    return getOrientation(context) == .landscape;
  }

  /// Get safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }
}

/// Responsive widget builder
//   class ResponsiveBuilder extends StatelessWidget {
//     final
//   const ResponsiveBuilder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {

//     },);
//   }
// }

// Responsive layout widget for different device types
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({super.key, required this.mobile, this.tablet});
  final Widget mobile;
  final Widget? tablet;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Breakpoints.mobile) {
          return mobile;
        } else {
          return tablet ?? mobile;
        }
      },
    );
  }
}

/// Responsive grid configuration
class ResponsiveGridConfig {
  final int mobileCrossAxisCount;
  final int tabletCrossAxisCount;
  final double mobileAspectRatio;
  final double tabletAspectRatio;
  final double mobileSpacing;
  final double tableSpacing;

  ResponsiveGridConfig({
    this.mobileCrossAxisCount = 2,
    this.tabletCrossAxisCount = 3,
    this.mobileAspectRatio = 1.0,
    this.tabletAspectRatio = 1.0,
    this.mobileSpacing = 12,
    this.tableSpacing = 16,
  });

  int getCrossAxisCount(BuildContext context) {
    return ResponsiveHelper.isMobile(context)
        ? mobileCrossAxisCount
        : tabletCrossAxisCount;
  }

  double getAspectRatio(BuildContext context) {
    return ResponsiveHelper.isMobile(context)
        ? mobileAspectRatio
        : tabletAspectRatio;
  }

  double getSpacing(BuildContext context) {
    return ResponsiveHelper.isMobile(context) ? mobileSpacing : tableSpacing;
  }
}
