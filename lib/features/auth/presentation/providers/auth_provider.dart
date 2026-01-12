import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/features/auth/service/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();

  // state variable for loading indicator
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // store signed-in user's name
  String? _userName;
  String? get userName => _userName;

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
      _userName = name; // Set displayName in FirebaseAuth
      // save name locally
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // login
  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    try {
      await _authService.login(email: email, password: password);
      // optionally fetch user profile from Firestore here
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // log out
  Future<void> logout() async {
    _setLoading(true);
    await _authService.logout();
    _userName = null; // clear name on logout
    _setLoading(false);
    notifyListeners();
  }

  // forgot password
  Future<void> sendPasswordResetEmail({required String email}) async {
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email: email);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
