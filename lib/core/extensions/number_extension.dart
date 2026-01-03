import 'package:flutter/material.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';

extension ResponsiveNum on num {
  double w(BuildContext context) =>
      ResponsiveDimensions.getResponsiveSize(context, size: toDouble());

  double h(BuildContext context) =>
      ResponsiveDimensions.getResponsiveSize(context, size: toDouble());
}
