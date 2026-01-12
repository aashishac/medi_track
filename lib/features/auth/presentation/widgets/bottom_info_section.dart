import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';

class BottomInfoSection extends StatelessWidget {
  const BottomInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: context.sp12,
      children: [
        Divider(color: AppColors.divider),
        Row(
          mainAxisAlignment: .center,
          spacing: context.sp4,
          children: [
            Icon(Icons.lock, size: context.sp12, color: AppColors.textHint),
            Text(
              "Protected by HIPPA standards",
              style: AppTextStyle.bodyRegular(
                context,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
