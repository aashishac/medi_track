class FormValidator {
  static String? validateEmail(String? value) {
    if (value!.isEmpty || value == "") {
      return "Email field is required";
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value!.isEmpty || value == "") {
      return "Name field is required";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty || value == "") {
      return "Password field is required";
    }
    return null;
  }

  static String? validateConfirmPassword(
    String password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm Password field is required";
    }

    if (password.isEmpty) {
      return "Please enter password first";
    }

    if (confirmPassword.trim() != password.trim()) {
      return "Passwords do not match";
    }

    return null;
  }
}
