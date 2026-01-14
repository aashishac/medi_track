import 'package:flutter_test/flutter_test.dart';
import 'package:meditrack/features/home/models/patient.dart';
import 'package:meditrack/features/home/services/firestore_db.dart';
import 'package:meditrack/features/patient/presentation/providers/patient_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// mock class for FirestoreDb
@GenerateMocks([FirestoreDb])
import 'patient_provider_unit_test.mocks.dart';

void main() {
  late PatientProvider patientProvider;
  late MockFirestoreDb mockDb;

  // runs before every single test
  setUp(() {
    mockDb = MockFirestoreDb();

    // inject the mock db into the provider
    patientProvider = PatientProvider(db: mockDb);
  });

  // dummy data
  final tPatient1 = Patient(
    id: '1',
    name: 'john doe',
    gender: 'male',
    doctorId: '234',
  );

  final tPatient2 = Patient(
    id: '2',
    name: 'Priya Rai',
    gender: 'female',
    doctorId: '234',
  );

  final tPatientList = [tPatient1, tPatient2];

  group("Patient provider unit tests", () {
    test("Initial values should be default", () {
      expect(patientProvider.patients, isEmpty);
      expect(patientProvider.isLoading, false);
      expect(patientProvider.selectedFilter, "all");
    });

    test("init() should fetch data and update the list", () async {
      // 1. arrange
      when(
        mockDb.fetchPatientData(any),
      ).thenAnswer((realInvocation) => Stream.value(tPatientList));

      // 2. act
      patientProvider.init('234');

      // 3. assert
      await Future.delayed(Duration.zero);
      expect(patientProvider.patients.length, 2);
      expect(patientProvider.patients, contains(tPatient1));
    });

    test("Filter logic: search should filter patients by name", () async {
      // arrange: load data first
      when(
        mockDb.fetchPatientData(any),
      ).thenAnswer((realInvocation) => Stream.value(tPatientList));

      patientProvider.init('234');
      await Future.delayed(Duration.zero);

      // act: search for john
      patientProvider.search('john');

      // assert: only john should remain in the list
      expect(patientProvider.patients.length, 1);
      expect(patientProvider.patients.first.name, "john doe");
    });

    test(
      "delete patient should call DB delete and handle loading state",
      () async {
        // arange
        when(
          mockDb.deletePatient(any),
        ).thenAnswer((realInvocation) => Future.value());

        // act
        final future = patientProvider.deletePatient('1');

        // check loading state immediately after call
        expect(patientProvider.isLoading, true);

        await future;

        // assert
        expect(patientProvider.isLoading, false); // loading should stop
        verify(mockDb.deletePatient('1')).called(1);
        expect(patientProvider.error, isNull); // no error expected
      },
    );
  });
}
