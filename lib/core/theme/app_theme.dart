import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/theme/app_text_theme.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.surfaceWhite,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlue,
        secondary: AppColors.infoBlue,
        surface: AppColors.surfaceWhite,
        error: AppColors.errorRed,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),

      textTheme: AppTextTheme.of(context),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyle.bodySemiBold(
          context,
          fontSize: 16,
          lineHeight: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Input Decoration (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        hintStyle: AppTextStyle.bodyRegular(
          context,
        ).copyWith(color: AppColors.textHint),
        errorStyle: AppTextStyle.bodyRegular(
          context,
        ).copyWith(color: AppColors.errorRed),

        suffixIconColor: AppColors.textHint,
        prefixIconColor: AppColors.textHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),

      // ElevatedButton Theme (Main Buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            vertical: 8,
            horizontal: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size(double.infinity, 50), // Full width default
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0, // Design looks flat with border/shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 16),
      ),

      // Chip Theme (Status tags)
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.iconBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
      ),

      iconTheme: IconThemeData(size: context.sp16, color: AppColors.textHint),
    );
  }
}
