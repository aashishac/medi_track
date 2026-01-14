import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditrack/features/home/models/doctor.dart';
import 'package:meditrack/features/home/services/firestore_db.dart';

class UserProvider with ChangeNotifier {
  final FirestoreDb _db;
  final FirebaseAuth _auth;

  UserProvider({FirestoreDb? db, FirebaseAuth? auth})
    : _db = db ?? FirestoreDb(),
      _auth = auth ?? FirebaseAuth.instance; // use injected auth

  Doctor? _doctor;
  bool _isLoading = false;
  String? _error;

  Doctor? get doctor => _doctor;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Example: method that uses auth
  String? get currentUid => _auth.currentUser?.uid;

  Future<void> completeDoctorProfile(Doctor doctor) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _db.saveDoctorProfile(doctor);
      _doctor = doctor;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDoctorData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedDoctor = await _db.fetchDoctorData();
      _doctor = fetchedDoctor;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
