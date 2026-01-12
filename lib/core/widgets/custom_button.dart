import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';

class CustomButton extends StatelessWidget {
  /// Custom Reusable Button Widget
  const CustomButton({
    super.key,
    this.height,
    required this.onTap,
    this.horizontal = 0,
    required this.buttonLabel,
    this.isLoading = false,
    this.textColor,
    this.fontSize,
    this.lineHeight,
    this.isOutlined = false,
  });

  /// Button's height
  final double? height;

  /// button label text
  final String buttonLabel;

  /// Button's on tap function
  final void Function()? onTap;

  /// Padding value for horizontal
  final double horizontal;

  /// loading checker
  final bool isLoading;

  /// outline checker
  final bool isOutlined;

  /// button label text color
  final Color? textColor;

  /// text font size
  final double? fontSize;

  /// text line height
  final double? lineHeight;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: horizontal,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOutlined
                ? AppColors.errorBg
                : AppColors.primaryBlue,
            foregroundColor: AppColors.surfaceWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isOutlined
                    ? AppColors.errorRed.withValues(alpha: 0.4)
                    : Colors.transparent,
              ),
            ),
          ),
          child: isLoading
              ? CircularProgressIndicator(
                  color: isOutlined
                      ? AppColors.primaryBlue
                      : AppColors.surfaceWhite,
                )
              : Text(
                  buttonLabel,
                  style: AppTextStyle.bodyRegular(
                    context,
                    color: textColor ?? AppColors.surfaceWhite,
                    fontSize: fontSize ?? 18,
                    lineHeight: lineHeight ?? 27,
                  ),
                ),
        ),
      ),
    );
  }
}
