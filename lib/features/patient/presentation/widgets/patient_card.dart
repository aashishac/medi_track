import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/features/home/models/patient.dart';
import 'package:meditrack/features/patient/presentation/pages/patient_detail_page.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patient});

  final Patient patient;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveDimensions.getResponsiveSize(context, size: 140),
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: 16,
        vertical: 12,
      ),
      margin: ResponsiveDimensions.paddingOnly(context, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceWhite,
      ),
      child: Column(
        spacing: context.sp8,
        children: [
          Row(
            spacing: context.sp8,
            children: [
              // profile
              CircleAvatar(radius: context.sp20),

              // name and id
              Column(
                children: [
                  Text(patient.name, style: AppTextStyle.bodySemiBold(context)),
                  Text(
                    "ID:${patient.id}",
                    style: AppTextStyle.bodyMedium(
                      context,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // status chip
              StatusChip(),
            ],
          ),
          SizedBox(height: context.sp4),
          Divider(color: AppColors.divider),

          // time info and detail navigation
          Row(
            spacing: context.sp4,
            children: [
              Icon(Icons.calendar_today),
              Text(
                "Last Visit: Oct 24, 2023",
                style: AppTextStyle.bodyMedium(
                  context,
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              Spacer(),
              //patient detail page navigation button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientDetailPage(patient: patient),
                    ),
                  );
                },
                child: Container(
                  padding: ResponsiveDimensions.paddingSymmetric(
                    context,
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.infoBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    "View Details",
                    style: AppTextStyle.bodySemiBold(
                      context,
                      fontSize: 12,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ResponsiveDimensions.paddingSymmetric(
        context,
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.warningBg),
      ),
      child: Text(
        "Admitted",
        style: AppTextStyle.bodySemiBold(
          context,
          fontSize: 12,
          color: AppColors.warningOrange,
        ),
      ),
    );
  }
}
