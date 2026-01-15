import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    final padding = EdgeInsets.symmetric(
      horizontal: ResponsiveHelper.getResponsiveValue<double>(
        context: context,
        mobile: 20,
        tablet: 40,
      ),
      vertical: ResponsiveHelper.getResponsiveValue<double>(
        context: context,
        mobile: 14,
        tablet: 28,
      ),
    );

    final iconSize = ResponsiveHelper.getResponsiveValue<double>(
      context: context,
      mobile: 26,
      tablet: 32,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceWhite,
        boxShadow: const [
          BoxShadow(color: AppColors.divider, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Icon(
                  Icons.folder_shared_sharp,
                  size: iconSize,
                  color: AppColors.infoBlue,
                ),
              ),

              /// New badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.successGreen.withValues(alpha: 0.2),
                ),
                child: Text(
                  "+3 New",
                  style: AppTextStyle.bodyMedium(
                    context,
                    color: AppColors.successGreen,
                    fontSize: isMobile ? 12 : 13,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.sp16),

          /// Count + label
          Text(
            "12",
            style: AppTextStyle.headingSemiBold(
              context,
              fontSize: isMobile ? 24 : 32,
            ),
          ),
          SizedBox(height: context.sp4),
          Text(
            "Pending Patient Records",
            style: AppTextStyle.bodyMedium(
              context,
              fontSize: isMobile ? 14 : 16,
            ),
          ),

          SizedBox(height: context.sp16),
          const Divider(color: AppColors.divider),

          /// Footer row
          Row(
            children: [
              const Icon(
                Icons.access_time_filled,
                size: 16,
                color: AppColors.textHint,
              ),
              SizedBox(width: context.sp4),
              Text(
                "Updated 10 mins ago",
                style: AppTextStyle.bodyRegular(
                  context,
                  fontSize: isMobile ? 12 : 14,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                iconAlignment: IconAlignment.end,
                label: Text(
                  "Review",
                  style: AppTextStyle.bodySemiBold(
                    context,
                    color: AppColors.primaryBlue,
                    fontSize: isMobile ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
