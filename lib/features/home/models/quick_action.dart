import 'package:flutter/material.dart';

class QuickAction {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final Function(BuildContext context) onTap;

  QuickAction({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}
