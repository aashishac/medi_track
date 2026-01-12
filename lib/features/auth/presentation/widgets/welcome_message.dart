import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // welcome message
        Text(title, style: AppTextStyle.headingSemiBold(context)),

        Text(
          subtitle,
          textAlign: .center,
          style: AppTextStyle.bodyRegular(context, color: AppColors.textHint),
        ),
      ],
    );
  }
}
