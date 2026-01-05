import 'package:flutter/widgets.dart';

class PasswordToggleProvider with ChangeNotifier {
  bool _isPasswordVissible = true;
  bool _isConfirmPassVissible = true;

  bool get isPassVisibile => _isPasswordVissible;
  bool get isConfirmPassVisibile => _isConfirmPassVissible;

  void togglePasswordVisibility() {
    _isPasswordVissible = !_isPasswordVissible;
    notifyListeners();
  }

  void toggleConfirmPassVisibility() {
    _isConfirmPassVissible = !_isConfirmPassVissible;
    notifyListeners();
  }
}
