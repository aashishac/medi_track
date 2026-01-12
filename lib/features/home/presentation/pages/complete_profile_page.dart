import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/utils/snack_bar_helper.dart';
import 'package:meditrack/core/validators/form_validator.dart';
import 'package:meditrack/core/widgets/custom_button.dart';
import 'package:meditrack/core/widgets/custom_label_text_field.dart';
import 'package:meditrack/core/widgets/custom_text_field.dart';
import 'package:meditrack/features/home/models/doctor.dart';
import 'package:meditrack/features/home/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _departmentController = TextEditingController();
  final _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _departmentController.dispose();
    _phoneController.dispose();
  }

  void completeProfile() async {
    if (formKey.currentState!.validate()) {
      final provider = context.read<UserProvider>();
      await provider.completeDoctorProfile(
        Doctor(
          doctorId: "",
          phone: _phoneController.text.trim(),
          department: _departmentController.text.trim(),
        ),
      );
      if (provider.error == null && mounted) {
        SnackBarHelper.showSuccess(context, "Successfully completed profile");
        await provider.fetchDoctorData();
        if (mounted) {
          Navigator.pop(context);
        }
      } else if (mounted) {
        SnackBarHelper.showError(context, provider.error ?? "an error occured");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              spacing: context.sp12,
              mainAxisAlignment: .center,
              children: [
                // TODO: implement doctor profile uploading
                Container(
                  height: ResponsiveDimensions.getResponsiveSize(
                    context,
                    size: 90,
                  ),
                  width: ResponsiveDimensions.getResponsiveSize(
                    context,
                    size: 90,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    shape: .circle,
                  ),
                  child: Icon(Icons.person),
                ),

                CustomLabelTextField(
                  labelText: "Department",
                  customTextField: CustomTextField(
                    controller: _departmentController,
                    hintText: "Enter your department name",
                  ),
                ),

                // phone input
                CustomLabelTextField(
                  labelText: "Phone",
                  customTextField: CustomTextField(
                    controller: _phoneController,
                    hintText: "Enter your phone number",
                    validator: (value) =>
                        FormValidators.validatePhoneNumber(value),
                  ),
                ),
                SizedBox(height: context.sp12),

                Consumer<UserProvider>(
                  builder: (context, value, child) {
                    return CustomButton(
                      onTap: completeProfile,
                      buttonLabel: "Complete profile",
                      isLoading: value.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
