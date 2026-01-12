import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_text_style.dart';

class HeadingLabel extends StatelessWidget {
  const HeadingLabel({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyle.headingSemiBold(context, fontSize: 20),
    );
  }
}
