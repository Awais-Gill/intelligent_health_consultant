import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intelligent_health_consultant/Modals/appointment.dart';
import 'package:intelligent_health_consultant/Modals/Doctor.dart';
import 'package:intelligent_health_consultant/Modals/user.dart';
import 'package:intelligent_health_consultant/login.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> login({required String email, required String password}) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Additional user information
      User? user = userCredential.user;
      if (user != null) {
        pref.setString('uid', user.uid);

        pref.setBool('isLoggedIn', true);
        return true; // Sign-In successful
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
    return false; // Sign-up failed
  }

  Future<bool> signUp(
    BuildContext context, {
    required String email,
    required String password,
    required String name,
    required String contact,
    required String gender,
    String? role,
    String? qualification,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Additional user information
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);

        // Store additional user info in Firestore
        if (role == null) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': name,
            'email': email,
            'gender': gender,
            'contact': contact,
            'role': role ?? 'p', // Default Role
          });
        } else {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': name,
            'email': email,
            'contact': contact,
            'gender': gender,
            'role': role,
            'qualification': qualification,
          });
        }
        pref.setBool('isLoggedIn', true);
        pref.setString('uid', user.uid);
      }
      return true; // Sign-up successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The password provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email')));
      }
    } catch (e) {
      print(e);
    }
    return false; // Sign-up failed
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      await _auth.signOut().then((value) {
        pref.setBool('isLoggedIn', false);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future<bool> createDoctor(
    BuildContext context, {
    required String email,
    required String password,
    required String name,
    required String contact,
    required String gender,
    required String qualification,
  }) async {
    bool response = await signUp(
      context,
      email: email,
      password: password,
      name: name,
      contact: contact,
      gender: gender,
      role: "d",
      qualification: qualification,
    );
    return response;
  }

  Future<List<Doctor>> fetchDoctors() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .where("role", isEqualTo: 'd')
        .get();
    List<Doctor> doctors =
        querySnapshot.docs.map((doc) => Doctor.fromJson(doc.data())).toList();
    return doctors;
  }

  Future<List<Appointment>> fetchAppointments(String id, String role) async {
    print(role);
    List<Appointment> appointments;

    if (role == "patient") {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where("patient.uid", isEqualTo: id)
          .get();

      appointments = querySnapshot.docs
          .map((doc) => Appointment.fromMap(doc.data()))
          .toList();
    } else {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where("doctor.uid", isEqualTo: id)
          .get();

      appointments = querySnapshot.docs
          .map((doc) => Appointment.fromMap(doc.data()))
          .toList();
    }

    print('appointments.length: ${appointments.length}');
    return appointments;
  }

  Future<UserModel?> getUserByUid(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        print(userDoc.data());

        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        print('User with UID $uid does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting user by UID: $e');
      return null;
    }
  }

  Future<bool> addNewAppointment(
    UserModel patient,
    Doctor doctor,
    String dateTime,
    String symptoms,
  ) async {
    CollectionReference appointments =
        FirebaseFirestore.instance.collection('appointments');

    String appointmentId = appointments.doc().id;

    try {
      await appointments.doc(appointmentId).set({
        'id': appointmentId,
        'patient': patient.toJson(),
        'doctor': doctor.toMap(),
        'dateTime': dateTime,
        'symptoms': symptoms,
      });

      return true;
    } catch (error) {
      print("Failed to add appointment: $error");
      return false;
    }
  }
}
