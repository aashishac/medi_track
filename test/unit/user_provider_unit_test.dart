import 'package:flutter_test/flutter_test.dart';
import 'package:meditrack/features/home/models/doctor.dart';
import 'package:meditrack/features/home/presentation/providers/user_provider.dart';
import 'package:meditrack/features/home/services/firestore_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([FirestoreDb, FirebaseAuth, User])
import 'user_provider_unit_test.mocks.dart';

void main() {
  late MockFirestoreDb mockDb;
  late MockFirebaseAuth mockAuth;
  late UserProvider userProvider;

  setUp(() {
    mockDb = MockFirestoreDb();
    mockAuth = MockFirebaseAuth();

    userProvider = UserProvider(db: mockDb, auth: mockAuth);
  });

  group('UserProvider Unit Tests', () {
    test('1. initial state', () {
      expect(userProvider.doctor, isNull);
      expect(userProvider.isLoading, false);
      expect(userProvider.error, isNull);
    });

    test('2. completeDoctorProfile calls saveDoctorProfile', () async {
      final doctor = Doctor(
        doctorId: 'test_uid_123',
        phone: '9800000000',
        department: 'Cardiology',
      );

      when(mockDb.saveDoctorProfile(any)).thenAnswer((_) async {});

      await userProvider.completeDoctorProfile(doctor);

      verify(mockDb.saveDoctorProfile(doctor)).called(1);
    });

    test('3. fetchDoctorData sets doctor correctly', () async {
      final dummyDoctor = Doctor(
        doctorId: 'test_uid_123',
        phone: '9811111111',
        department: 'Neurology',
      );

      when(mockDb.fetchDoctorData()).thenAnswer((_) async => dummyDoctor);

      await userProvider.fetchDoctorData();

      expect(userProvider.doctor?.department, 'Neurology');
    });

    test('4. completeDoctorProfile sets error on failure', () async {
      final doctor = Doctor(
        doctorId: 'test_uid_123',
        phone: '9800000000',
        department: 'Cardiology',
      );

      when(mockDb.saveDoctorProfile(any)).thenThrow(Exception('DB Error'));

      await userProvider.completeDoctorProfile(doctor);

      expect(userProvider.error, contains('DB Error'));
    });

    test('5. fetchDoctorData sets error on failure', () async {
      when(mockDb.fetchDoctorData()).thenThrow(Exception('Fetch Error'));

      await userProvider.fetchDoctorData();

      expect(userProvider.error, contains('Fetch Error'));
      expect(userProvider.doctor, isNull);
    });
  });
}
