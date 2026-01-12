import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/utils/snack_bar_helper.dart';
import 'package:meditrack/core/validators/form_validator.dart';
import 'package:meditrack/core/widgets/custom_button.dart';
import 'package:meditrack/core/widgets/custom_label_text_field.dart';
import 'package:meditrack/core/widgets/custom_text_field.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/auth/presentation/widgets/welcome_message.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();
      provider.sendPasswordResetEmail(email: _emailController.text.trim());
      if (provider.errorMessage != null) {
        SnackBarHelper.showError(context, provider.errorMessage!);
        return;
      } else {
        SnackBarHelper.showInfo(context, "Please check your email");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .start,
            spacing: context.sp12,
            children: [
              WelcomeMessage(
                title: "Forgot Password",
                subtitle: "Enter your email to get reset link",
              ),

              // email input
              CustomLabelTextField(
                labelText: AppStrings.emailLabel,
                customTextField: CustomTextField(
                  controller: _emailController,
                  keyboardType: .emailAddress,
                  prefixIcon: Icon(Icons.email, size: context.sp16),
                  hintText: AppStrings.emailHint,
                  validator: (value) => FormValidators.validateEmail(value),
                ),
              ),
              SizedBox(height: context.sp48),
              // continue button
              Selector<AuthProvider, bool>(
                selector: (_, value) => value.isLoading,
                builder: (context, value, child) => CustomButton(
                  onTap: _sendResetLink,
                  buttonLabel: AppStrings.continueBtn,
                  isLoading: value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
