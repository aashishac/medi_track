import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_text_style.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme of(BuildContext context) {
    return TextTheme(
      // Headlines
      headlineLarge: AppTextStyle.headingRegular(context),
      headlineMedium: AppTextStyle.headingSemiBold(context),

      // Body
      bodyLarge: AppTextStyle.bodySemiBold(context),
      bodyMedium: AppTextStyle.bodyMedium(context),
      bodySmall: AppTextStyle.bodyRegular(context),

      // Labels
      labelLarge: AppTextStyle.labelSemiBold(context),
      labelMedium: AppTextStyle.labelMedium(context),
      labelSmall: AppTextStyle.labelRegular(context),
    );
  }
}
