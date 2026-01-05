import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';

class AppTextStyle {
  AppTextStyle._();
  static const String _fontFamily = 'Inter';

  /// BASE STYLE
  /// These should not be used directly in UI
  /// They act as foundations for variants
  static TextStyle _base({
    required BuildContext context,
    required double fontSize,
    required FontWeight fontWeight,
    required double lineHeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontWeight: fontWeight,
      fontSize: ResponsiveDimensions.getResponsiveSize(context, size: fontSize),
      color: color ?? AppColors.textPrimary,
      height: lineHeight / fontSize,
    );
  }

  // Display/Large text styles
  static TextStyle headingRegular(
    BuildContext context, {
    double fontSize = 28,
    double lineHeight = 32,
    Color? color,
  }) => _base(
    context: context,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    lineHeight: lineHeight,
    color: color,
  );

  static TextStyle headingSemiBold(
    BuildContext context, {
    double fontSize = 24,
    double lineHeight = 32,
    Color? color,
  }) => _base(
    context: context,
    fontSize: fontSize,
    lineHeight: lineHeight,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // body
  static TextStyle bodyRegular(
    BuildContext context, {
    double fontSize = 12,
    double lineHeight = 18,
    Color? color,
  }) => _base(
    context: context,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    lineHeight: lineHeight,
    color: color,
  );

  static TextStyle bodySemiBold(
    BuildContext context, {
    double fontSize = 14,
    double lineHeight = 18,
    Color? color,
  }) => bodyRegular(
    context,
    fontSize: fontSize,
    lineHeight: lineHeight,
    color: color,
  ).copyWith(fontWeight: FontWeight.w600);

  static TextStyle bodyMedium(
    BuildContext context, {
    double fontSize = 14,
    double lineHeight = 18,
    Color? color,
  }) => bodyRegular(
    context,
    fontSize: fontSize,
    lineHeight: lineHeight,
    color: color,
  ).copyWith(fontWeight: FontWeight.w500);

  // Labels
  static TextStyle labelRegular(
    BuildContext context, {
    double fontSize = 10,
    double lineHeight = 14,
    Color? color,
  }) => _base(
    context: context,
    fontSize: fontSize,
    fontWeight: FontWeight.w400,
    lineHeight: lineHeight,
    color: color,
  );

  static TextStyle labelMedium(
    BuildContext context, {
    double fontSize = 10,
    double lineHeight = 14,
    Color? color,
  }) => labelRegular(
    context,
    fontSize: fontSize,
    lineHeight: lineHeight,
    color: color,
  ).copyWith(fontWeight: FontWeight.w500);

  static TextStyle labelBold(
    BuildContext context, {
    double fontSize = 12,
    double lineHeight = 14,
    Color? color,
  }) => _base(
    context: context,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    lineHeight: lineHeight,
    color: color,
  );

  static TextStyle labelSemiBold(
    BuildContext context, {
    double fontSize = 16,
    double lineHeight = 20,
    Color? color,
  }) => _base(
    context: context,
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    lineHeight: lineHeight,
    color: color,
  );
}
