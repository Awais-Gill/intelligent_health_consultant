import 'package:flutter/material.dart';
import 'package:intelligent_health_consultant/profile.dart';
import 'package:intelligent_health_consultant/services/firbase_services.dart';
import 'Modals/Doctor.dart';

class Doctors extends StatefulWidget {
  const Doctors({Key? key}) : super(key: key);

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> with SingleTickerProviderStateMixin {
  late Future<List<Doctor>> doctors;
  final FirebaseServices _firebaseServices = FirebaseServices();
  @override
  void initState() {
    doctors = _firebaseServices.fetchDoctors();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.green,
        title: const Text(
          'Choose Doctor',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: FutureBuilder<List<Doctor>>(
        future: doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Doctor doctor = snapshot.data![index];
                return Card(
                  color: Colors.pink,
                  elevation: 20,
                  margin: const EdgeInsets.all(40),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Profile(doctor: doctor)));
                    },
                    child: SizedBox(
                      height: 100,
                      child: ListTile(
                        leading: const Icon(
                          Icons.medical_services,
                          color: Colors.blue,
                        ),
                        title: Text(
                          doctor.name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 30),
                        ),
                        subtitle: Text(
                          doctor.qualification,
                          style: const TextStyle(
                              color: Colors.green, fontSize: 25),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
