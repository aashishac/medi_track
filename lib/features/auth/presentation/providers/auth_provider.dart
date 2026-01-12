import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/features/auth/service/auth_service.dart';
import 'package:meditrack/features/home/models/doctor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();
  final _doctorService = DoctorService();

  // state variable for loading indicator
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // store signed-in user's name
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _userId;
  Doctor? _doctor;

  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  String? get userId => _userId;
  Doctor? get doctor => _doctor;
  String? _profileImagePath;
  String? get profileImagePath => _profileImagePath;

  /// Load  data from FirebaseAuth
  void loadUser() {
    final name = _authService.currentUserName;
    final email = _authService.currentUserEmail;
    final phone = _authService.currentUserPhone;
    final id = _authService.currentUserId;

    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _userId = id;
    notifyListeners();
  }

  ///Name loads after login

  ///Name persists after restart

  ///Name clears on logout

  AuthProvider() {
    _authService.authStateChanges.listen((user) async {
      if (user != null) {
        _userName = user.displayName;
        _userEmail = user.email;
        _userPhone = user.phoneNumber;
        _userId = user.uid;

        // 🔥 Fetch full doctor data
        _doctor = await _doctorService.getDoctorById(user.uid);
      } else {
        _userName = null;
        _userEmail = null;
        _userPhone = null;
        _userId = null;
        _doctor = null;
      }
      notifyListeners();
    });
  }

  ///images eetup from imagepicker

  /// Load image when app starts
  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    _profileImagePath = prefs.getString('profile_image');
    notifyListeners();
  }

  /// Save image after picking
  Future<void> setProfileImage(String path) async {
    _profileImagePath = path;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);

    notifyListeners();
  }

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
