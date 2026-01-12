import 'package:flutter/material.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';

extension ResponsiveUtils on BuildContext {
  double get scaleFactor => ResponsiveDimensions.getScaleFactor(this);

  // spacings
  double get sp4 => ResponsiveDimensions.spacing4(this);
  double get sp8 => ResponsiveDimensions.spacing8(this);
  double get sp12 => ResponsiveDimensions.spacing12(this);
  double get sp16 => ResponsiveDimensions.spacing16(this);
  double get sp20 => ResponsiveDimensions.spacing20(this);
  double get sp48 => ResponsiveDimensions.spacing48(this);
}
