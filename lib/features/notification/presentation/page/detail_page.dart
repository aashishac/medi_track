import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_text_style.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.title, required this.description});
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail page')),
      body: SafeArea(
        child: Column(
          children: [
            Text(title, style: AppTextStyle.headingRegular(context)),
            Text(description, style: AppTextStyle.bodyMedium(context)),
          ],
        ),
      ),
    );
  }
}
