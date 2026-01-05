import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';

Widget customTextfleid({
  required String hintText,
  required Widget suffixIcon,
  TextEditingController? controller,
  bool obscureText = false,
  TextInputType? keyboardType,
  final String? Function(String? value)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      TextFormField(
        controller: controller, // <- FIXED: use the controller
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          focusColor: AppColors.inputBorder,
          hintText: hintText,
          suffixIcon: suffixIcon,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          filled: true,
          fillColor: AppColors.iconBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    ],
  );
}
