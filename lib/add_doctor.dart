import 'package:flutter/material.dart';
import 'package:intelligent_health_consultant/services/firbase_services.dart';

class AddDoctor extends StatefulWidget {
  const AddDoctor({Key? key}) : super(key: key);

  @override
  State<AddDoctor> createState() => _AddDoctorState();
}

class _AddDoctorState extends State<AddDoctor> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final qualificationController = TextEditingController();

  final passwordController = TextEditingController();
  final genderController = TextEditingController();
  final contactController = TextEditingController();
  final FirebaseServices _firebaseServices = FirebaseServices();

  clearControllers() {
    nameController.clear();
    emailController.clear();
    qualificationController.clear();
    passwordController.clear();
    genderController.clear();
    contactController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Doctor")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                controller: qualificationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Qualification',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                controller: genderController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gender',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contact',
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await _firebaseServices
                      .createDoctor(context,
                          email: emailController.text.trim(),
                          password: passwordController.text,
                          name: nameController.text.trim(),
                          contact: contactController.text.trim(),
                          gender: genderController.text.trim(),
                          qualification: qualificationController.text.trim())
                      .then((value) {
                    if (value) {
                      clearControllers();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Doctor Account Created')));
                    }
                  });
                },
                child: const Text('Add Doctor'))
          ],
        ),
      ),
    );
  }
}
