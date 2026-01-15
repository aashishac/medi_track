import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
import 'package:meditrack/features/home/models/quick_action.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key, required this.quickAction});
  final QuickAction quickAction;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = ResponsiveHelper.isTablet(context);
        return Container(
          padding: ResponsiveDimensions.paddingSymmetricAdaptive(
            context,
            mobileHorizontal: 16,
            mobileVertical: 32,
            tabletHorizontal: 20,
            tabletVertical: 16,
          ),
          height: ResponsiveDimensions.getResponsiveSize(context, size: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: quickAction.bgColor,
          ),
          child: Column(
            spacing: context.sp4,
            crossAxisAlignment: .start,
            children: [
              // icon container
              Container(
                padding: ResponsiveDimensions.paddingOnly(
                  context,
                  left: 7,
                  right: 7,
                  bottom: 12,
                  top: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  quickAction.icon,
                  size: ResponsiveDimensions.getResponsiveSize(
                    context,
                    size: context.sp20,
                  ),
                  color: quickAction.iconColor,
                ),
              ),

              FittedBox(
                fit: .scaleDown,
                child: Text(
                  quickAction.title,
                  style: AppTextStyle.headingSemiBold(
                    context,
                    fontSize: isTablet ? 18 : 16,
                  ),
                ),
              ),

              FittedBox(
                fit: .scaleDown,
                child: Text(
                  quickAction.subtitle,
                  style: AppTextStyle.bodyRegular(
                    context,
                    color: Colors.brown,
                    fontSize: isTablet ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
