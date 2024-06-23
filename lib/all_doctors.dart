import 'package:flutter/material.dart';
import 'package:intelligent_health_consultant/services/firbase_services.dart';

import 'Modals/Doctor.dart';

class AllDoctors extends StatefulWidget {
  const AllDoctors({Key? key}) : super(key: key);

  @override
  State<AllDoctors> createState() => _AllDoctorsState();
}

class _AllDoctorsState extends State<AllDoctors> {
  late Future<List<Doctor>> doctorsFuture;
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    doctorsFuture = _firebaseServices.fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Doctors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Doctor>>(
          future: doctorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Contact')),
                ],
                rows: snapshot.data!.map((doctor) {
                  return DataRow(cells: [
                    DataCell(Text(doctor.name)),
                    DataCell(Text(doctor.contact)),
                  ]);
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
