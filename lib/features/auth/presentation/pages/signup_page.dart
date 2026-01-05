import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/core/responsive/responsive_dimensions.dart';
import 'package:meditrack/core/validators/form_validator.dart';
import 'package:meditrack/features/auth/presentation/pages/Login_page.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:meditrack/features/auth/presentation/widgets/button_widget.dart';
import 'package:meditrack/features/auth/presentation/widgets/textfield_widgets2.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isChecked = false;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  } // handle registration

  void createAccount() async {
    if (_formKey.currentState!.validate()) {
      // continue login process
      await context.read<AuthProvider>().signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LoginPage();
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginPage();
                },
              ),
            );
          },
        ),
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: ResponsiveDimensions.paddingH20(context),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Text(
                  AppStrings.createAccount,
                  style: TextStyle(fontSize: 28, fontWeight: .w500),
                ),

                Padding(
                  padding: ResponsiveDimensions.paddingH20(context),
                  child: Text(
                    'Join MediTrack to manage your practise securely and efficiently',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center, // center both lines
                    softWrap: true, // allow wrapping
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Full name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    customTextfleid2(
                      hintText: "Dr. john Doe",
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      validator: (value) => FormValidator.validateName(value),
                      controller: _nameController,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    customTextfleid2(
                      hintText: "name@hospital.com",
                      prefixIcon: Icon(Icons.mail, color: Colors.grey),
                      validator: (value) => FormValidator.validateEmail(value),
                      controller: _emailController,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    customTextfleid2(
                      hintText: "+977981*******",
                      prefixIcon: Icon(Icons.phone, color: Colors.grey),
                      controller: _phoneController,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    customTextfleid2(
                      hintText: "***********",
                      controller: _passwordController,
                      prefixIcon: Icon(Icons.password, color: Colors.grey),
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                      validator: (value) =>
                          FormValidator.validatePassword(value),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    customTextfleid2(
                      controller: _confirmPassController,
                      hintText: "***********",
                      prefixIcon: Icon(
                        Icons.replay_outlined,
                        color: Colors.grey,
                      ),
                      suffixIcon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                      validator: (value) =>
                          FormValidator.validateConfirmPassword(
                            _passwordController.text.trim(),
                            value,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Checkbox(
                      side: BorderSide(color: AppColors.inputBorder),
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked = newValue!;
                        });
                      },
                    ),
                    Text('I agree to the', style: TextStyle(fontSize: 14)),

                    Text(
                      ' Terms of service &',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.infoBlue,
                      ),
                    ),
                    Text(
                      ' Privacy policy ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.infoBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Selector<AuthProvider, bool>(
                  selector: (_, value) => value.isLoading,
                  builder: (context, value, child) => CustomButton(
                    onPressed: () {
                      createAccount();
                    },

                    isLoading: value,
                    child: Text(
                      'Create Account',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: .center,
                  spacing: 5,
                  children: [
                    Text(
                      'Already have an account ?',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ),
                        );
                      },

                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.infoBlue,
                        ),
                      ),
                    ), // redirect section
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
