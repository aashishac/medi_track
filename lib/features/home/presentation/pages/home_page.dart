import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/home/presentation/widgets/heading_label.dart';
import 'package:meditrack/features/home/presentation/widgets/overview_card.dart';
import 'package:meditrack/features/home/presentation/widgets/quick_grid_list.dart';
import 'package:meditrack/features/profile/presentation/pages/profile_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final imagePath = context.watch<AuthProvider>().profileImagePath;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveDimensions.paddingSymmetric(
              context,
              horizontal: 24,
            ),
            child: Column(
              spacing: context.sp16,
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    // welcoming message with current date
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: "Good Morning, ",
                            style: AppTextStyle.bodySemiBold(
                              context,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "Dr. ${context.watch<AuthProvider>().userName ?? "Guest"}",
                                style: AppTextStyle.bodySemiBold(
                                  context,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(DateFormat('EEEE, MMM d').format(DateTime.now())),
                      ],
                    ),
                    // profile image
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundImage: imagePath != null
                            ? FileImage(File(imagePath))
                            : const AssetImage("assets/profileimg.png"),
                      ),
                    ),
                  ],
                ),

                // patient overview
                OverviewCard(),

                // quick action section
                HeadingLabel(label: "Quick Actions"),
                QuickGridList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
