import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meditrack/features/home/models/patient.dart';
import 'package:meditrack/features/home/services/firestore_db.dart';

enum FilterCategory { all, apointments, male, female }

class PatientProvider with ChangeNotifier {
  final _db = FirestoreDb();

  // internal list
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];

  StreamSubscription? _patientsSubscription;

  // error
  String? _error;

  // patient id
  String? _patientId;

  // loading indicator
  bool _isLoading = false;

  // filter state
  String _searchQuery = "";
  String _selectedFilter = FilterCategory.all.name;

  // getters
  List<Patient> get patients => _filteredPatients;
  String get selectedFilter => _selectedFilter;
  String? get error => _error;
  String? get patientId => _patientId;
  bool get isLoading => _isLoading;

  // search functionality
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // filter
  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // initialize and listen to stream
  void init(String doctorId) {
    // cancel existing subscription if any to avoid duplicates
    _patientsSubscription?.cancel();

    _patientsSubscription = _db.fetchPatientData(doctorId).listen((patients) {
      _allPatients = patients;
      _applyFilters();
    });
  }

  Stream<List<Patient>> fetchPatientDataList(String doctorId) {
    return _db.fetchPatientData(doctorId);
  }

  // combine search + filter
  void _applyFilters() {
    _filteredPatients = _allPatients.where((patient) {
      // gender filter
      bool matchGender =
          _selectedFilter == FilterCategory.all.name ||
          patient.gender.toLowerCase() == _selectedFilter.toLowerCase();

      // searched query (name)
      bool matchSearch = patient.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      return matchSearch && matchGender;
    }).toList();
  }

  Future<void> addUpdatePatient(Patient patient) async {
    try {
      _error = null;
      _setLoading(true);
      await _db.addPatientRecord(patient);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchNextPatientId() async {
    try {
      _error = null;
      _setLoading(true);
      _patientId = await _db.getNextPatientId();
    } catch (e) {
      _error = e.toString();
      log(_error!);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      _error = null;
      _setLoading(true);
      await _db.deletePatient(patientId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _patientsSubscription?.cancel();
  }
}
