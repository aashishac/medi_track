import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/constants/app_text_style.dart';
import 'package:meditrack/core/extensions/context_extension.dart';
import 'package:meditrack/core/network/connectivity_provider.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/responsive/responsive_helper.dart';
import 'package:meditrack/core/utils/snack_bar_helper.dart';
import 'package:meditrack/core/validators/form_validator.dart';
import 'package:meditrack/core/widgets/custom_button.dart';
import 'package:meditrack/core/widgets/custom_label_text_field.dart';
import 'package:meditrack/core/widgets/custom_text_field.dart';
import 'package:meditrack/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:meditrack/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:meditrack/features/auth/presentation/pages/sign_up_page.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/auth/presentation/providers/password_toggle_provider.dart';
import 'package:meditrack/features/auth/presentation/widgets/bottom_info_section.dart';
import 'package:meditrack/features/auth/presentation/widgets/redirect_section.dart';
import 'package:meditrack/features/auth/presentation/widgets/welcome_message.dart';
import 'package:meditrack/features/home/presentation/pages/home_page.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Track last known connection state
  late bool _lastKnownConnectionState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ConnectivityProvider>();
      _lastKnownConnectionState = provider.isConnected;
      provider.addListener(_connectionListener);
    });
  }

  void _connectionListener() {
    final provider = context.read<ConnectivityProvider>();
    final isNowConnected = provider.isConnected;
    if (!mounted) return;
    if (_lastKnownConnectionState && !isNowConnected) {
      SnackBarHelper.showError(context, "No internet");
    } else if (!_lastKnownConnectionState && isNowConnected) {
      SnackBarHelper.showSuccess(context, "Internet connected");
    }

    _lastKnownConnectionState = isNowConnected;
  }

  // Login function
  void _login() async {
    final authProvider = context.read<AuthProvider>();

    await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    // Show error if login failed
    if (authProvider.errorMessage != null) {
      SnackBarHelper.showError(context, authProvider.errorMessage!);
      return;
    }
    if (!mounted) return;
    SnackBarHelper.showSuccess(context, "Successfully logged in");

    // ✅ Email-based admin redirect
    final email = _emailController.text.trim().toLowerCase();
    if (email == "aboutadvertisementinc@gmail.com") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboardPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    // Remove connectivity listener
    context.read<ConnectivityProvider>().removeListener(_connectionListener);

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    return ChangeNotifierProvider(
      create: (_) => PasswordToggleProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 600 : double.infinity,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: ResponsiveDimensions.paddingSymmetricAdaptive(
                    context,
                    mobileHorizontal: 24,
                    tabletHorizontal: 48,
                    mobileVertical: 16,
                    tabletVertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: WelcomeMessage(
                          title: AppStrings.welcomeBack,
                          subtitle: AppStrings.signInSubtitle,
                        ),
                      ),
                      SizedBox(height: context.sp16),

                      // Email input
                      CustomLabelTextField(
                        labelText: AppStrings.emailLabel,
                        customTextField: CustomTextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.email, size: context.sp16),
                          hintText: AppStrings.emailHint,
                          validator: FormValidators.validateEmail,
                        ),
                      ),
                      SizedBox(height: context.sp16),

                      // Password input
                      CustomLabelTextField(
                        labelText: AppStrings.passwordLabel,
                        customTextField: Selector<PasswordToggleProvider, bool>(
                          selector: (_, value) => value.isPassVisibile,
                          builder: (context, isHidden, child) =>
                              CustomTextField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: isHidden,
                                suffixIcon: IconButton(
                                  onPressed: () => context
                                      .read<PasswordToggleProvider>()
                                      .togglePasswordVisibility(),
                                  icon: Icon(
                                    isHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: context.sp16,
                                  ),
                                ),
                                hintText: AppStrings.passwordHint,
                                validator: FormValidators.validatePassword,
                              ),
                        ),
                      ),
                      SizedBox(height: context.sp16),

                      // Forgot password
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          AppStrings.forgotPassword,
                          style: AppTextStyle.bodyMedium(
                            context,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      SizedBox(height: context.sp16),

                      // Login button
                      Consumer<AuthProvider>(
                        builder: (context, provider, child) => CustomButton(
                          onTap: provider.isLoading ? null : _login,
                          buttonLabel: AppStrings.loginBtn,
                          isLoading: provider.isLoading,
                        ),
                      ),
                      SizedBox(height: context.sp16),

                      // Redirect section
                      RedirectSection(
                        infoText: AppStrings.dontHaveAccount,
                        redirectLinkText: AppStrings.signUpBtn,
                        navigateTo: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpPage()),
                          );
                        },
                      ),
                      SizedBox(height: context.sp20),

                      // Bottom info section
                      BottomInfoSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
