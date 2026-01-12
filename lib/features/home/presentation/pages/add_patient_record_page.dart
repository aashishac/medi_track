import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/extensions/string_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/utils/snack_bar_helper.dart';
import 'package:meditrack/core/validators/form_validator.dart';
import 'package:meditrack/core/widgets/custom_button.dart';
import 'package:meditrack/core/widgets/custom_label_text_field.dart';
import 'package:meditrack/core/widgets/custom_text_field.dart';
import 'package:meditrack/features/home/models/patient.dart';
import 'package:meditrack/features/home/presentation/pages/complete_profile_page.dart';
import 'package:meditrack/features/home/presentation/providers/user_provider.dart';
import 'package:meditrack/features/patient/presentation/providers/patient_provider.dart';
import 'package:provider/provider.dart';

enum Gender { male, female }

class AddPatientRecordPage extends StatefulWidget {
  const AddPatientRecordPage({super.key, this.existedPatient});

  final Patient? existedPatient;
  @override
  State<AddPatientRecordPage> createState() => _AddPatientRecordPageState();
}

class _AddPatientRecordPageState extends State<AddPatientRecordPage> {
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Gender? selectedGender;
  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.existedPatient != null) {
      _nameController.text = widget.existedPatient!.name;
      selectedGender = Gender.values.byName(widget.existedPatient!.gender);
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<UserProvider>();

      if (provider.doctor == null && !provider.isLoading) {
        // show dialog box to complete profile
        _showCompleteProfileDialog();
      }
    });
  }

  // dialog for completing the profile
  void _showCompleteProfileDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Profile Incomplete'),
          content: Text(
            'Complete your profile with phone number and department',
          ),
          actions: [
            CustomButton(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompleteProfilePage(),
                  ),
                );
              },
              buttonLabel: "Complete profile",
            ),
          ],
        );
      },
    );
  }

  // saving patient record
  Future<void> save() async {
    if (formKey.currentState!.validate()) {
      if (selectedGender == null) {
        return SnackBarHelper.showError(context, "Please select gender");
      }

      final provider = context.read<PatientProvider>();
      if (widget.existedPatient != null) {
        final patientData = Patient(
          id: widget.existedPatient!.id,
          name: _nameController.text.trim(),
          gender: selectedGender!.name,
          doctorId: widget.existedPatient!.doctorId,
        );
        // updating existed data
        await provider.addUpdatePatient(patientData);

        if (mounted) {
          if (provider.error == null) {
            SnackBarHelper.showSuccess(
              context,
              "Patient record updated successfully",
            );
            Navigator.pop(context);
            return;
          } else {
            return SnackBarHelper.showError(context, provider.error!);
          }
        }
      }

      // actual adding
      await provider.fetchNextPatientId();
      if (provider.patientId != null && provider.error == null) {
        final doctorId = FirebaseAuth.instance.currentUser!.uid;
        provider.addUpdatePatient(
          Patient(
            id: provider.patientId!,
            name: _nameController.text.trim(),
            gender: selectedGender!.name,
            doctorId: doctorId,
          ),
        );
        if (provider.error == null && mounted) {
          SnackBarHelper.showSuccess(
            context,
            "Successfully saved patient record",
          );
          Navigator.pop(context);
        }
      } else if (mounted && provider.error != null) {
        SnackBarHelper.showError(context, provider.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existedPatient != null
              ? "Update patient record"
              : 'Add pateint record',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              spacing: context.sp12,
              children: [
                SizedBox(height: context.sp12),
                // patient name
                CustomLabelTextField(
                  labelText: "Patient Name",
                  customTextField: CustomTextField(
                    controller: _nameController,
                    hintText: "enter name",
                    validator: (value) =>
                        FormValidators.validateUsername(value),
                  ),
                ),
                // gender
                CustomLabelTextField(
                  labelText: "Gender",
                  customTextField: SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: selectedGender,
                      items: Gender.values
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender.name.capitalize(),
                                style: AppTextStyle.bodyMedium(context),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: context.sp12),
                // add button
                Selector<PatientProvider, bool>(
                  selector: (_, provider) => provider.isLoading,
                  builder: (context, value, child) => CustomButton(
                    onTap: save,
                    buttonLabel: widget.existedPatient != null
                        ? "Update record"
                        : "Add record",
                    isLoading: value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
