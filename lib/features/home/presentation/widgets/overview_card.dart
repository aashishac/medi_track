import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceWhite,
        boxShadow: [
          BoxShadow(color: AppColors.divider, blurRadius: 8, spreadRadius: 2),
        ],
      ),
      child: Padding(
        padding: ResponsiveDimensions.paddingSymmetric(
          context,
          horizontal: 16,
          vertical: 14,
        ),
        child: Column(
          crossAxisAlignment: .start,
          spacing: context.sp12,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                // folder icon
                Container(
                  padding: ResponsiveDimensions.paddingSymmetric(
                    context,
                    horizontal: 7,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Icon(
                    Icons.folder_shared_sharp,
                    size: ResponsiveDimensions.getResponsiveSize(
                      context,
                      size: 30,
                    ),
                    color: AppColors.infoBlue,
                  ),
                ),

                // shows new patients number
                Container(
                  padding: ResponsiveDimensions.paddingSymmetric(
                    context,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: AppColors.successGreen.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    "+3 New",
                    style: AppTextStyle.bodyMedium(
                      context,
                      color: AppColors.successGreen,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            // pending patients number
            Column(
              crossAxisAlignment: .start,
              children: [
                Text("12", style: AppTextStyle.headingSemiBold(context)),
                Text(
                  "Pending Patient Records",
                  style: AppTextStyle.bodyMedium(context),
                ),
              ],
            ),
            SizedBox(height: context.sp12),
            Divider(color: AppColors.divider),

            // time + review navigation
            Row(
              children: [
                Icon(Icons.access_time_filled, color: AppColors.textHint),
                Text(
                  "Updated 10 mins ago",
                  style: AppTextStyle.bodyRegular(context),
                ),
                Spacer(),
                // navigate to review section
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward),
                  iconAlignment: .end,
                  label: Text(
                    "Review",
                    style: AppTextStyle.bodySemiBold(
                      context,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
