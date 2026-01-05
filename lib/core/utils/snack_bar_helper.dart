import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';

enum SnackBarType { success, error, info, warning }

class SnackBarHelper {
  SnackBarHelper._();

  // success snack bar
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(context, message: message, type: .success);
  }

  // error snack bar
  static void showError(BuildContext context, String message) {
    _showSnackBar(context, message: message, type: .error);
  }

  // info snack bar
  static void showInfo(BuildContext context, String message) {
    _showSnackBar(context, message: message, type: .info);
  }

  // warning snack bar
  static void showWarning(BuildContext context, String message) {
    _showSnackBar(context, message: message, type: .warning);
  }

  // snackbar
  static void _showSnackBar(
    BuildContext context, {
    required String message,
    required SnackBarType type,
  }) {
    final config = _getSnackbarConfig(type);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          spacing: context.sp8,
          children: [
            // snack icon
            Icon(
              config.icon,
              color: AppColors.surfaceWhite,
              size: context.sp16,
            ),
            // snack message
            Text(
              message,
              style: AppTextStyle.bodyMedium(
                context,
                color: AppColors.surfaceWhite,
              ),
            ),
          ],
        ),
        backgroundColor: config.bgColor,
        behavior: .floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static _SnackbarConfig _getSnackbarConfig(SnackBarType type) {
    switch (type) {
      case .success:
        return _SnackbarConfig(
          bgColor: AppColors.successGreen,
          icon: Icons.check_circle,
        );
      case .error:
        return _SnackbarConfig(bgColor: AppColors.errorRed, icon: Icons.error);

      case .info:
        return _SnackbarConfig(
          bgColor: AppColors.primaryBlue,
          icon: Icons.info,
        );
      case .warning:
        return _SnackbarConfig(
          bgColor: AppColors.warningOrange,
          icon: Icons.warning,
        );
    }
  }
}

class _SnackbarConfig {
  final Color bgColor;
  final IconData icon;

  _SnackbarConfig({required this.bgColor, required this.icon});
}
