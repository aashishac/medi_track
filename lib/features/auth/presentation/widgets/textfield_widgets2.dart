import 'package:flutter/material.dart';
import 'package:meditrack/core/constants/app_colors.dart';

Widget customTextfleid2({
  required String hintText,
  required Icon prefixIcon,
  Icon? suffixIcon,
  final String? Function(String? value)? validator,
  TextEditingController? controller,
  onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 8),
      TextFormField(
        decoration: InputDecoration(
          focusColor: AppColors.inputBorder,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText, //acc to requirement

          hintStyle: TextStyle(color: Colors.grey),
          //acc to requirement
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),

          filled: true,
          fillColor: AppColors.iconBackground,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        validator: validator,
      ),
    ],
  );
}
