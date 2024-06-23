import 'package:flutter/material.dart';

import 'package:intelligent_health_consultant/Modals/appointment.dart';
import 'package:intelligent_health_consultant/services/firbase_services.dart';

class Appointments extends StatefulWidget {
  final String userId;
  final String role;
  const Appointments({
    Key? key,
    required this.userId,
    required this.role,
  }) : super(key: key);

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  late Future<List<Appointment>> futureAppointments;

  late FirebaseServices _firebaseServices;

  @override
  void initState() {
    print(widget.role);
    print(widget.userId);
    _firebaseServices = FirebaseServices();
    futureAppointments = _firebaseServices.fetchAppointments(
      widget.userId,
      widget.role,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Appointments")),
      body: FutureBuilder<List<Appointment>>(
        future: futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No appointments found'));
          } else {
            return DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Symptoms')),
                DataColumn(label: Text('Date')),
              ],
              rows: snapshot.data!.map((appointment) {
                return DataRow(cells: [
                  DataCell(Text(widget.role == "doctor"
                      ? appointment.patient!.name ?? ""
                      : appointment.doctor!.name)),
                  DataCell(Text(
                    appointment.symptoms ?? "",
                    maxLines: 2,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  )),
                  DataCell(Text(appointment.date ?? "")),
                ]);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
