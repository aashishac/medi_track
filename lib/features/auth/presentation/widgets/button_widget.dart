import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final bool isLoading; // <- pass real loading state
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.isLoading = false, // default false
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveDimensions.getResponsiveSize(size: 310, context),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: isOutlined ? AppColors.primaryBlue : Colors.white,
          backgroundColor: isOutlined
              ? Colors.transparent
              : AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: ResponsiveDimensions.paddingAll16(context),
        ),
        onPressed: isLoading ? null : onPressed, // disable while loading
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isOutlined ? AppColors.primaryBlue : Colors.white,
                ),
              )
            : child,
      ),
    );
  }
}
