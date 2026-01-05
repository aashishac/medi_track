import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/network/connectivity_provider.dart';
import 'package:meditrack/core/utils/snack_bar_helper.dart';
import 'package:meditrack/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:meditrack/features/auth/presentation/pages/signup_page.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/auth/presentation/providers/password_toggle_provider.dart';
import 'package:meditrack/features/auth/presentation/widgets/button_widget.dart';
import 'package:meditrack/features/auth/presentation/widgets/textfield_widgets.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasswordToggleProvider()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// TITLE
                    Text(
                      AppStrings.welcomeBack,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sign in to manage health care data',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    /// FORM
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          customTextfleid(
                            controller: _emailController,
                            hintText: "Enter your email",
                            keyboardType: TextInputType.emailAddress,
                            suffixIcon: const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),

                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Selector<PasswordToggleProvider, bool>(
                            selector: (_, value) => value.isPassVisibile,
                            builder: (context, value, child) => customTextfleid(
                              controller: _passwordController,
                              hintText: "Enter your password",
                              obscureText: value,
                              keyboardType: TextInputType.visiblePassword,
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

                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// FORGOT PASSWORD
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.infoBlue,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// LOGIN BUTTON
                    Selector<AuthProvider, bool>(
                      builder: (context, value, child) => CustomButton(
                        onPressed: () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          // Check empty fields
                          if (email.isEmpty || password.isEmpty) {
                            SnackBarHelper.showError(
                              context,
                              "Please enter both email and password",
                            );
                            return;
                          }

                          try {
                            await context.read<AuthProvider>().login(
                              email: email,
                              password: password,
                            );

                            if (!mounted) return; // Correct check
                            SnackBarHelper.showSuccess(
                              context,
                              "Successfully logged in",
                            );

                            // Navigate to dashboard if needed
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                },
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            if (!mounted) return;
                            SnackBarHelper.showError(
                              context,
                              e.message ??
                                  "Login failed. Check your credentials.",
                            );
                          } catch (e) {
                            if (!mounted) return;
                            SnackBarHelper.showError(
                              context,
                              "Login failed. Please try again.",
                            );
                          }
                        },
                        child: Text('Login', style: TextStyle(fontSize: 16)),
                        isLoading: value,
                      ),
                      selector: (_, value) => value.isLoading,
                    ),

                    const SizedBox(height: 24),

                    /// SIGN UP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don’t have an account?'),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.infoBlue,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// FOOTER
                    const Text(
                      'Powered by HIPAA Standards',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
