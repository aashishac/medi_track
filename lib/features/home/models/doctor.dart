// ignore_for_file: public_member_api_docs, sort_constructors_first
class Doctor {
  final String? doctorId; // later we'll assign it using uid
  final String phone;
  final String department;

  Doctor({
    required this.doctorId,
    required this.phone,
    required this.department,
  });

  // firestore document to model
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorId'],
      phone: json['phone'],
      department: json['department'],
    );
  }

  // from model to json
  Map<String, dynamic> toMap() => {
    'doctorId': doctorId,
    'phone': phone,
    'department': department,
  };

  Doctor copyWith({String? doctorId, String? phone, String? department}) {
    return Doctor(
      doctorId: doctorId ?? this.doctorId,
      phone: phone ?? this.phone,
      department: department ?? this.department,
    );
  }
}
