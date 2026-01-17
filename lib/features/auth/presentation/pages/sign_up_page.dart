import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
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
    final isTablet = ResponsiveHelper.isTablet(context);

    final content = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: isTablet ? context.sp20 : context.sp16,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? context.sp12 : context.sp8,
            ),
            child: WelcomeMessage(
              title: AppStrings.createAccount,
              subtitle: AppStrings.signUpSubtitle,
            ),
          ),

          CustomLabelTextField(
            labelText: AppStrings.fullNameLabel,
            customTextField: CustomTextField(
              controller: _nameController,
              prefixIcon: Icon(Icons.person, size: 18),
              hintText: AppStrings.nameHint,
              validator: (value) => FormValidators.validateUsername(value),
            ),
          ),

          CustomLabelTextField(
            labelText: AppStrings.emailLabel,
            customTextField: CustomTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email, size: 18),
              hintText: AppStrings.emailHint,
              validator: (value) => FormValidators.validateEmail(value),
            ),
          ),

          CustomLabelTextField(
            labelText: AppStrings.passwordLabel,
            customTextField: CustomTextField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Icon(Icons.lock, size: 18),
              suffixIcon: Icon(Icons.visibility, size: 18),
              hintText: AppStrings.passwordHint,
              validator: (value) => FormValidators.validatePassword(value),
            ),
          ),

          CustomLabelTextField(
            labelText: AppStrings.confirmPassLabel,
            customTextField: CustomTextField(
              controller: _cofirmPassController,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Icon(Icons.lock_outline, size: 18),
              suffixIcon: Icon(Icons.visibility, size: 18),
              hintText: AppStrings.confirmPassHint,
              validator: (value) => FormValidators.validateConfirmPassword(
                value,
                _passwordController.text.trim(),
              ),
            ),
          ),

          CheckboxSection(value: false, onChanged: (_) {}),

          Selector<AuthProvider, bool>(
            selector: (_, p) => p.isLoading,
            builder: (_, loading, __) => CustomButton(
              onTap: createAccount,
              buttonLabel: AppStrings.createAccount,
              isLoading: loading,
            ),
          ),

          RedirectSection(
            infoText: AppStrings.alreadyHaveAccount,
            redirectLinkText: AppStrings.loginBtn,
            navigateTo: () => Navigator.pop(context),
          ),

          SizedBox(height: context.sp20),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 16,
            vertical: isTablet ? 24 : 16,
          ),
          child: isTablet
              ? Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: content,
                  ),
                )
              : content,
        ),
      ),
    );
  }
}
