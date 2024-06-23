// class LoginResponse {
//   // late String? error;
//   late String? id, name, password, email, gender, contact;
//   String? qualification = 'none';

//   LoginResponse(
//       {required this.id,
//       required this.name,
//       required this.password,
//       required this.qualification,
//       required this.gender,
//       required this.contact,
//       required this.email});

//   Map<String, dynamic> toMap() {
//     return {
//       // 'error': this.error,
//       'id': id,
//       'name': name,
//       'password': password,
//       'qualification': qualification,
//       'gender': gender,
//     };
//   }

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       id: json['id'] as String,
//       password: json['password'] as String,
//       name: json['name'] as String,
//       qualification: json['qualification'] as String?,
//       gender: json['gender'] as String,
//       email: json['email'] as String,
//       contact: json['contact'] as String,
//     );
//   }
// }
