import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
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
    final authProvider = context.watch<AuthProvider>();
    final auth = context.watch<AuthProvider>();
    final isMobile = ResponsiveHelper.isMobile(context);

    final horizontalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context: context,
      mobile: 20,
      tablet: 48,
    );

    final verticalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context: context,
      mobile: 12,
      tablet: 24,
    );

    final maxWidth = ResponsiveHelper.getResponsiveValue<double>(
      context: context,
      mobile: double.infinity,
      tablet: 720,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// Greeting
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Good Morning, ",
                                style: AppTextStyle.bodySemiBold(
                                  context,
                                  fontSize: isMobile ? 16 : 18,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "Dr. ${authProvider.userName ?? "Guest"}",
                                    style: AppTextStyle.bodySemiBold(
                                      context,
                                      fontSize: isMobile ? 16 : 18,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('EEEE, MMM d').format(DateTime.now()),
                              style: AppTextStyle.bodyRegular(
                                context,
                                fontSize: isMobile ? 13 : 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        /// Profile Image
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProfilePage(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: kIsWeb
                                ? (auth.profileImageBytes != null
                                      ? MemoryImage(auth.profileImageBytes!)
                                      : const AssetImage(
                                          'assets/profileimg.png',
                                        ))
                                : (auth.profileImagePath != null
                                          ? FileImage(
                                              File(auth.profileImagePath!),
                                            )
                                          : const AssetImage(
                                              'assets/profileimg.png',
                                            ))
                                      as ImageProvider,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),

                    /// Overview
                    const OverviewCard(),

                    SizedBox(height: 24),

                    /// Quick actions
                    const HeadingLabel(label: "Quick Actions"),
                    SizedBox(height: context.sp12),
                    const QuickGridList(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
