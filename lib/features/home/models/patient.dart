class Patient {
  final String id;
  final String name;
  final String gender;
  final String doctorId;

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.doctorId,
  });

  // flutter to firebase
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'gender': gender,
    'doctorId': doctorId,
  };

  // firestore to flutter
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      doctorId: json['doctorId'],
    );
  }
}
