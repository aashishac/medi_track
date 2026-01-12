import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/features/home/models/doctor.dart';
import 'package:meditrack/features/home/services/firestore_db.dart';

class UserProvider with ChangeNotifier {
  final db = FirestoreDb();
  final auth = FirebaseAuth.instance;
  Doctor? _doctor;
  String? _errorMessage;

  bool _isLoading = false;

  Doctor? get doctor => _doctor;
  bool get isLoading => _isLoading;
  String? get error => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // add doctor data
  Future<void> completeDoctorProfile(Doctor doctor) async {
    try {
      _errorMessage = null;
      _setLoading(true);
      await db.saveDoctorProfile(doctor);
    } catch (e) {
      _errorMessage = e.toString();
      log("Failed to add doctor data: $e");
    } finally {
      _setLoading(false);
    }
  }

  // add doctor data
  Future<void> fetchDoctorData() async {
    try {
      _errorMessage = null;
      _setLoading(true);
      _doctor = await db.fetchDoctorData();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      log("Failed to fetch doctor data: $e");
    } finally {
      _setLoading(false);
    }
  }
}
