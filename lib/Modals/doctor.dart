class Doctor {
  late String uid, name, qualification, email, gender, contact;

  Doctor(
      {required this.uid,
      required this.name,
      required this.qualification,
      required this.email,
      required this.gender,
      required this.contact});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'qualification': qualification,
      'email': email,
      'gender': gender,
      'contact': contact,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    print(json);
    return Doctor(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      qualification: json['qualification'] as String? ?? '',
      email: json['email'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      contact: json['contact'] as String? ?? '',
    );
  }
}
