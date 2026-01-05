import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/utils/snack_bar_helper.dart';
import 'package:meditrack/core/validators/form_validator.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/auth/presentation/widgets/button_widget.dart';
import 'package:meditrack/features/auth/presentation/widgets/textfield_widgets.dart';
import 'package:provider/provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Padding(
        padding: ResponsiveDimensions.paddingSymmetric(context, horizontal: 24),
        child: Column(
          crossAxisAlignment: .start,
          spacing: context.sp12,
          children: [
            Text('Forgot Password', style: TextStyle(fontSize: 22)),
            Text('Enter your email to get reset link"'),
            // email input
            customTextfleid(
              suffixIcon: Icon(Icons.mail),
              controller: _emailController,

              hintText: AppStrings.emailHint,
              validator: (value) => FormValidator.validateEmail(value),
            ),
            SizedBox(height: 8),
            // continue button
            Selector<AuthProvider, bool>(
              selector: (_, value) => value.isLoading,
              builder: (context, value, child) => CustomButton(
                onPressed: () async {
                  await context.read<AuthProvider>().sendPasswordResetEmail(
                    email: _emailController.text.trim(),
                  );
                  if (context.mounted) {
                    SnackBarHelper.showInfo(
                      context,
                      "Please check your email for the reset link",
                    );
                  }
                },
                isLoading: value,
                child: Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
