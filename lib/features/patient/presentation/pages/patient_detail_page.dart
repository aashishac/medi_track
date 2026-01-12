import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/utils/snack_bar_helper.dart';
import 'package:meditrack/core/widgets/custom_button.dart';
import 'package:meditrack/features/home/models/patient.dart';
import 'package:meditrack/features/home/presentation/pages/add_patient_record_page.dart';
import 'package:meditrack/features/patient/presentation/providers/patient_provider.dart';
import 'package:provider/provider.dart';

class PatientDetailPage extends StatelessWidget {
  const PatientDetailPage({super.key, required this.patient});
  final Patient patient;

  Future<void> deleteRecord(BuildContext context) async {
    final provider = context.read<PatientProvider>();
    await provider.deletePatient(patient.id);

    if (context.mounted) {
      if (provider.error == null) {
        SnackBarHelper.showSuccess(
          context,
          "Patient record is deleted successfully",
        );
        Navigator.pop(context);
      } else {
        SnackBarHelper.showError(context, provider.error!);
        return;
      }
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete this record"),
        content: Text("Are you sure about deleting this record?"),
        actions: [
          Row(
            mainAxisAlignment: .center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Details"),
        actions: [
          Container(
            height: ResponsiveDimensions.getResponsiveSize(context, size: 35),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddPatientRecordPage(existedPatient: patient),
                  ),
                );
              },
              icon: Icon(Icons.edit, color: AppColors.surfaceWhite),
            ),
          ),
          SizedBox(width: context.sp16),
        ],
      ),
      body: Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: Column(
          children: [
            Text(patient.name),
            Spacer(),
            Selector<PatientProvider, bool>(
              selector: (_, value) => value.isLoading,
              builder: (context, value, child) => CustomButton(
                onTap: () async {
                  final result = await _showConfirmationDialog(context);
                  if (result && context.mounted) {
                    await deleteRecord(context);
                  }
                },
                isLoading: value,
                buttonLabel: "Delete",
                isOutlined: true,
                textColor: AppColors.errorRed,
              ),
            ),
            SizedBox(height: context.sp20),
          ],
        ),
      ),
    );
  }
}
