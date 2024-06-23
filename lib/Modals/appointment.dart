import 'package:intelligent_health_consultant/Modals/Doctor.dart';
import 'package:intelligent_health_consultant/Modals/user.dart';

class Appointment {
  String? id;
  UserModel? patient;
  String? symptoms;
  Doctor? doctor;
  String? date;

  Appointment({
    this.id,
    this.patient,
    this.symptoms,
    this.doctor,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patient': patient?.toJson(),
      'symptoms': symptoms,
      'doctor': doctor?.toMap(),
      'date': date,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    print(map);
    return Appointment(
      id: map['id'] != null ? map['id'] as String : null,
      patient: map['patient'] != null
          ? UserModel.fromJson(map['patient'] as Map<String, dynamic>)
          : null,
      symptoms: map['symptoms'] != null ? map['symptoms'] as String : null,
      doctor: map['doctor'] != null
          ? Doctor.fromJson(map['doctor'] as Map<String, dynamic>)
          : null,
      date: map['dateTime'] != null ? map['dateTime'] as String : null,
    );
  }
}
