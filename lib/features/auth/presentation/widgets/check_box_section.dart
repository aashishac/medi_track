import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';

class CheckboxSection extends StatelessWidget {
  const CheckboxSection({
    super.key,
    this.labelText,
    required this.value,
    required this.onChanged,
    this.hasHighlightText = false,
  });

  /// check box side label text
  final String? labelText;

  /// Check box actual value
  final bool value;

  /// Check box on changed function
  final void Function(bool? value)? onChanged;

  /// To check whether the text content has highlighted parts
  /// by default false
  final bool hasHighlightText;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: context.sp8,
      children: [
        SizedBox(width: context.sp4),
        SizedBox(
          width: context.sp8,
          height: context.sp8,
          child: Checkbox(value: value, onChanged: onChanged),
        ),
        RichText(
          text: TextSpan(
            text: 'I agree to the ',
            style: AppTextStyle.bodyRegular(context, fontSize: 14),
            children: [
              TextSpan(
                text: 'Terms of Service ',
                style: AppTextStyle.bodySemiBold(
                  context,
                  color: AppColors.primaryBlue,
                ),
              ),
              TextSpan(text: 'and '),
              TextSpan(
                text: 'Privacy Policy.',
                style: AppTextStyle.bodySemiBold(
                  context,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
