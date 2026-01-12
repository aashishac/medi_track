import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditrack/core/constants/app_strings.dart';
import 'package:meditrack/features/home/models/doctor.dart';
import 'package:meditrack/features/home/models/patient.dart';

class FirestoreDb {
  // instance of firestore
  final db = FirebaseFirestore.instance;

  // instance of db
  static final _instance = FirestoreDb._();
  FirestoreDb._();

  factory FirestoreDb() => _instance;

  // patient related functionality
  Future<void> addPatientRecord(Patient patient) async {
    try {
      await db
          .collection(AppStrings.patients)
          .doc(patient.id)
          .set(patient.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to add new patient record: $e");
    }
  }

  // Get the next formatted ID that grows dynamically
  Future<String> getNextPatientId() async {
    try {
      final counterRef = db.collection('metadata').doc('patient_counter');

      return await db.runTransaction((transaction) async {
        final snapshot = await transaction.get(counterRef);

        int currentCount = 0;
        if (snapshot.exists) {
          currentCount = snapshot.data()?['lastId'] ?? 0;
        }

        int nextId = currentCount + 1;

        // Update the counter in the DB
        transaction.set(counterRef, {
          'lastId': nextId,
        }, SetOptions(merge: true));

        // Format logic:
        // If nextId is < 10, it becomes "01", "02", etc.
        // If nextId is >= 10, it becomes "10", "100", "1000" automatically.
        String numericPart = nextId < 10
            ? nextId.toString().padLeft(2, '0')
            : nextId.toString();

        return "#Medi-$numericPart";
      });
    } catch (e) {
      throw Exception("Failed to generate sequential ID: $e");
    }
  }

  // delete patient data
  Future<void> deletePatient(String patientId) async {
    try {
      await db.collection(AppStrings.patients).doc(patientId).delete();
    } catch (e) {
      throw Exception("Failed to add delete patient record: $e");
    }
  }

  Stream<List<Patient>> fetchPatientData(String doctorId) {
    return db
        .collection(AppStrings.patients)
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((e) => Patient.fromJson(e.data())).toList(),
        );
  }

  // doctor related methods
  Future<void> saveDoctorProfile(Doctor doctor) async {
    try {
      final id = FirebaseAuth.instance.currentUser!.uid;
      final model = doctor.copyWith(doctorId: id);
      await db
          .collection(AppStrings.doctors)
          .doc(id)
          .set(model.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception("Failed to save doctor profile: $e");
    }
  }

  Future<Doctor?> fetchDoctorData() async {
    try {
      final id = FirebaseAuth.instance.currentUser!.uid;
      final docRef = db.collection(AppStrings.doctors).doc(id);

      final result = await docRef.get();
      if (result.data() == null) return null;
      return Doctor.fromJson(result.data()!);
    } catch (e) {
      throw Exception('Failed to fetch data : $e');
    }
  }
}
