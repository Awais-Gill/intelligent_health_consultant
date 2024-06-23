class UserModel {
  final String? uid;
  final String? role;
  final String? contact;
  final String? name;
  final String? email;
  final String? gender;

  UserModel({
    this.uid,
    this.role,
    this.contact,
    this.name,
    this.email,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      role: json['role'] ?? '',
      contact: json['contact'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'contact': contact,
      'name': name,
      'email': email,
      'gender': gender,
    };
  }
}
