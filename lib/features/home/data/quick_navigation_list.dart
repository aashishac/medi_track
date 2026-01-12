import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/features/home/models/quick_action.dart';
import 'package:meditrack/features/patient/presentation/pages/patient_record_list_page.dart';
import 'package:meditrack/features/profile/presentation/pages/profile_page.dart';
import 'package:meditrack/features/profile/presentation/pages/settings_page.dart';

final quickNavigationList = [
  QuickAction(
    icon: Icons.bar_chart,
    iconColor: AppColors.primaryBlue,
    bgColor: const Color.fromARGB(255, 138, 166, 211).withValues(alpha: 0.1),
    title: "Dashboard",
    subtitle: "View analytics",
    onTap: (context) {},
  ),

  QuickAction(
    icon: Icons.search,
    iconColor: AppColors.successGreen,
    bgColor: const Color.fromARGB(255, 151, 223, 177).withValues(alpha: 0.2),
    title: "Search",
    subtitle: "Find Records",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PatientRecordListPage()),
      );
    },
  ),

  QuickAction(
    icon: Icons.person,
    iconColor: AppColors.warningOrange,
    bgColor: AppColors.warningBg.withValues(alpha: 0.2),
    title: "My Profile",
    subtitle: "Update details",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    },
  ),

  QuickAction(
    icon: Icons.settings,
    iconColor: AppColors.textSecondary,
    bgColor: AppColors.surfaceWhite,
    title: "Settings",
    subtitle: "System prefs",
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    },
  ),
];
