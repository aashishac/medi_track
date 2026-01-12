import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/string_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/features/patient/presentation/providers/patient_provider.dart';
import 'package:provider/provider.dart';

class FilterChipList extends StatelessWidget {
  const FilterChipList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveDimensions.getResponsiveSize(context, size: 36),
      child: Consumer<PatientProvider>(
        builder: (context, value, child) => ListView.builder(
          scrollDirection: .horizontal,
          itemCount: FilterCategory.values.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                value.setFilter(FilterCategory.values[index].name);
              },
              child: FilterChip(
                label: FilterCategory.values[index].name,
                isActive:
                    value.selectedFilter.toLowerCase() ==
                    FilterCategory.values[index].name.toLowerCase(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip({super.key, required this.label, this.isActive = false});
  final String label;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .center,
      margin: ResponsiveDimensions.paddingOnly(context, right: 12),
      padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 14),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isActive ? Colors.transparent : AppColors.inputBorder,
        ),
      ),
      child: Text(
        label.capitalize(),
        style: AppTextStyle.bodyMedium(
          context,
          color: isActive ? AppColors.surfaceWhite : AppColors.textPrimary,
        ),
      ),
    );
  }
}
