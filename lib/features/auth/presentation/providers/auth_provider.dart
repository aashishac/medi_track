import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/features/auth/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();

  // state variable for loading indicator
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // helper to toggle loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // expose current login status
  bool get isLoggedIn => _authService.isLoggedIn;

  // create account
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    try {
      await _authService.signUp(email: email, password: password, name: name);
    } catch (e) {
      _setError(e.toString());
    } finally {
      // always stop loading , whether success or failure
      _setLoading(false);
    }
  }

  // login
  Future<void> login({required String email, required String password}) async {
    try {
      _isLoading = true;
      notifyListeners();
      _setLoading(true);
      await _authService.login(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Map FirebaseAuth codes to friendly messages
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No user found with this email";
          break;
        case 'wrong-password':
          message = "Incorrect email or password";
          break;
        case 'invalid-email':
          message = "Invalid email format";
          break;
        case 'user-disabled':
          message = "This account has been disabled";
          break;
        default:
          message = "Login failed. Please try again";
      }
      throw Exception(message); // Throw friendly message
    } catch (_) {
      throw Exception("Something went wrong");
    } finally {
      _isLoading = false;
      _setLoading(false);
    }
  }

  // log out
  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _setLoading(false);
  }

  // forgot password
  Future<void> sendPasswordResetEmail({required String email}) async {
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email: email);
    } catch (e) {
      _setError(e.toString());
    } finally {
      // always stop loading , whether success or failure
      _setLoading(false);
    }
  }
}
