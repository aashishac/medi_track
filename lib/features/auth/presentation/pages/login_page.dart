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
import 'package:meditrack/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:meditrack/features/auth/presentation/pages/sign_up_page.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/auth/presentation/providers/password_toggle_provider.dart';
import 'package:meditrack/features/auth/presentation/widgets/bottom_info_section.dart';
import 'package:meditrack/features/auth/presentation/widgets/redirect_section.dart';
import 'package:meditrack/features/auth/presentation/widgets/welcome_message.dart';
import 'package:meditrack/features/home/presentation/pages/tab_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // variable to keep track of the previous state for comparison
  late bool _laskKnownConnectionState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<ConnectivityProvider>();
      _laskKnownConnectionState = provider.isConnected;

      provider.addListener(_connectionListner);
    });
  }

  // this function runs every time the provider calls notifylistener
  void _connectionListner() {
    final provider = context.read<ConnectivityProvider>();
    bool isNowConnected = provider.isConnected;

    if (_laskKnownConnectionState && !isNowConnected) {
      // transition connected to disconnected
      SnackBarHelper.showError(context, "No internet");
    } else if (!_laskKnownConnectionState && isNowConnected) {
      // transition connected to disconnected
      SnackBarHelper.showSuccess(context, "Internet connected");
    }

    // update the local state tracker
    _laskKnownConnectionState = isNowConnected;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PasswordToggleProvider(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            // determine layout based on screen size
            final isMobile = ResponsiveHelper.isMobile(context);
            final isTablet = ResponsiveHelper.isTablet(context);
            return Center(
              child: ConstrainedBox(
                // limit max width for tablets
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
                      crossAxisAlignment: .start,
                      spacing: context.sp16,
                      mainAxisAlignment: .center,
                      children: [
                        // welcome
                        Center(
                          child: WelcomeMessage(
                            title: AppStrings.welcomeBack,
                            subtitle: AppStrings.signInSubtitle,
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
                            validator: (value) =>
                                FormValidators.validateEmail(value),
                          ),
                        ),

                        // password input
                        CustomLabelTextField(
                          labelText: AppStrings.passwordLabel,
                          customTextField:
                              Selector<PasswordToggleProvider, bool>(
                                selector: (_, value) => value.isPassVisibile,
                                builder: (context, value, child) =>
                                    CustomTextField(
                                      controller: _passwordController,
                                      keyboardType: .visiblePassword,
                                      obscureText: value,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          context
                                              .read<PasswordToggleProvider>()
                                              .togglePasswordVisibility();
                                        },
                                        icon: Icon(
                                          value
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: context.sp16,
                                        ),
                                      ),
                                      hintText: AppStrings.passwordHint,
                                      validator: (value) =>
                                          FormValidators.validatePassword(
                                            value,
                                          ),
                                    ),
                              ),
                        ),

                        // forgot password
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage(),
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

                        // login button
                        Consumer<AuthProvider>(
                          builder: (context, provider, child) => CustomButton(
                            onTap: () async {
                              await context.read<AuthProvider>().login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                              if (context.mounted &&
                                  provider.errorMessage == null) {
                                SnackBarHelper.showSuccess(
                                  context,
                                  "Successfully logged in",
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TabPage(),
                                  ),
                                );
                              }
                            },
                            buttonLabel: AppStrings.loginBtn,
                            isLoading: provider.isLoading,
                          ),
                        ),

                        // redirect section
                        RedirectSection(
                          infoText: AppStrings.dontHaveAccount,
                          redirectLinkText: AppStrings.signUpBtn,
                          navigateTo: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: context.sp20),

                        // bottom info section
                        BottomInfoSection(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
