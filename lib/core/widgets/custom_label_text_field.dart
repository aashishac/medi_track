import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';

class CustomLabelTextField extends StatelessWidget {
  const CustomLabelTextField({
    super.key,
    required this.labelText,
    required this.customTextField,
  });

  /// Label text
  final String labelText;

  /// Custom TextField widget
  final Widget customTextField;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: ResponsiveDimensions.getResponsiveSize(context, size: 4),
      children: [
        Text(labelText, style: AppTextStyle.bodySemiBold(context)),
        customTextField,
      ],
    );
  }
}
