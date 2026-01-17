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

  bool get isTablet => ResponsiveHelper.isTablet(context);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AuthProvider>();
    await provider.sendPasswordResetEmail(email: _emailController.text.trim());

    if (!mounted) return;

    if (provider.errorMessage != null) {
      SnackBarHelper.showError(context, provider.errorMessage!);
    } else {
      SnackBarHelper.showInfo(context, "Please check your email");
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.sp12,
        children: [
          WelcomeMessage(
            title: "Forgot Password",
            subtitle: "Enter your email to get reset link",
          ),

          /// Email
          CustomLabelTextField(
            labelText: AppStrings.emailLabel,
            customTextField: CustomTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icon(Icons.email, size: context.sp16),
              hintText: AppStrings.emailHint,
              validator: (value) => FormValidators.validateEmail(value),
            ),
          ),

          SizedBox(height: context.sp48),

          /// Continue
          Selector<AuthProvider, bool>(
            selector: (_, p) => p.isLoading,
            builder: (_, loading, __) => CustomButton(
              onTap: _sendResetLink,
              buttonLabel: AppStrings.continueBtn,
              isLoading: loading,
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 16,
            vertical: isTablet ? 24 : 16,
          ),
          child: isTablet
              ? Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: content,
                  ),
                )
              : content,
        ),
      ),
    );
  }
}
