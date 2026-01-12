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
import 'package:meditrack/features/auth/presentation/widgets/check_box_section.dart';
import 'package:meditrack/features/auth/presentation/widgets/redirect_section.dart';
import 'package:meditrack/features/auth/presentation/widgets/welcome_message.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cofirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _cofirmPassController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // handle registration
  void createAccount() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();
      await provider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text..trim(),
      );

      if (provider.errorMessage != null && mounted) {
        SnackBarHelper.showError(context, provider.errorMessage!);
      } else {
        if (mounted) {
          SnackBarHelper.showSuccess(context, AppStrings.registerSuccess);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: ResponsiveDimensions.paddingSymmetric(
            context,
            horizontal: 24,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: .start,
                spacing: context.sp16,
                mainAxisAlignment: .center,
                children: [
                  // welcome
                  Padding(
                    padding: ResponsiveDimensions.paddingSymmetric(
                      context,
                      horizontal: 18,
                    ),
                    child: WelcomeMessage(
                      title: AppStrings.createAccount,
                      subtitle: AppStrings.signUpSubtitle,
                    ),
                  ),

                  // name input
                  CustomLabelTextField(
                    labelText: AppStrings.fullNameLabel,
                    customTextField: CustomTextField(
                      controller: _nameController,
                      prefixIcon: Icon(Icons.person, size: context.sp16),
                      hintText: AppStrings.nameHint,
                      validator: (value) =>
                          FormValidators.validateUsername(value),
                    ),
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

                  // password input
                  CustomLabelTextField(
                    labelText: AppStrings.passwordLabel,
                    customTextField: CustomTextField(
                      controller: _passwordController,
                      keyboardType: .visiblePassword,
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.visibility, size: context.sp16),
                      ),
                      suffixIcon: Icon(Icons.visibility, size: context.sp16),
                      hintText: AppStrings.passwordHint,
                      validator: (value) =>
                          FormValidators.validatePassword(value),
                    ),
                  ),

                  //confirm password input
                  CustomLabelTextField(
                    labelText: AppStrings.confirmPassLabel,
                    customTextField: CustomTextField(
                      controller: _cofirmPassController,
                      keyboardType: .visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.visibility, size: context.sp16),
                      ),
                      prefixIcon: Icon(Icons.lock, size: context.sp16),
                      hintText: AppStrings.confirmPassHint,
                      validator: (value) =>
                          FormValidators.validateConfirmPassword(
                            value,
                            _passwordController.text.trim(),
                          ),
                    ),
                  ),

                  // terms and policy section
                  CheckboxSection(value: false, onChanged: (value) {}),

                  SizedBox(height: context.sp4),

                  // sign up button
                  Selector<AuthProvider, bool>(
                    selector: (_, value) => value.isLoading,
                    builder: (context, value, child) => CustomButton(
                      onTap: () {
                        createAccount();
                      },
                      buttonLabel: AppStrings.createAccount,
                      isLoading: value,
                    ),
                  ),

                  // redirect section
                  RedirectSection(
                    infoText: AppStrings.alreadyHaveAccount,
                    redirectLinkText: AppStrings.loginBtn,
                    navigateTo: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: context.sp20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
