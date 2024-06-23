// import 'package:flutter/material.dart';
// import 'package:intelligent_health_consultant/Modals/Appointment.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class NewActive extends StatefulWidget {
//   const NewActive({Key? key}) : super(key: key);

//   @override
//   _NewActiveState createState() => _NewActiveState();
// }

// class _NewActiveState extends State<NewActive> {
//   late Future<List<Appointment>> futureAppointments;

//   Future<List<Appointment>> fetchAppointments() async {
//     final response = await http.get(Uri.parse(
//         'https://doctorapplication.ahmadsaeed.net/api/appointmentpatient/1'));

//     if (response.statusCode == 200) {
//       return parseAppointments(response.body);
//     } else {
//       throw Exception();
//     }
//   }

//   List<Appointment> parseAppointments(String responseBody) {
//     final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//     return parsed
//         .map<Appointment>((json) => Appointment.fromMap(json))
//         .toList();
//   }

//   @override
//   void initState() {
//     futureAppointments = fetchAppointments();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Container(
//         height: 400,
//         width: 400,
//         // child: Padding(
//         //   padding: EdgeInsets.only(top: 20 , left: 10 , right: 10),
//         //   child: FutureBuilder<List<Appointment>>(
//         //     future: futureAppointments,
//         //     builder: (context, snapshot) {
//         //       if (snapshot.hasData){
//         //       return DataTable(columns: [
//         //         DataColumn(label: Text('Symptoms')),
//         //         DataColumn(label: Text('Patient')),
//         //         DataColumn(label: Text('Date')),
//         //       ], rows: getRows(snapshot.data!));
//         //       }
//         //       else
//         //       return CircularProgressIndicator.adaptive();
//         //     },
//         //   ),
//         // ),
//       ),
//     );
//   }

//   // List<DataRow> getRows(List<Appointment> list) {
//   //   List<DataRow> rows = [];

//   //   list.forEach((element) {
//   //     rows.add(DataRow(cells: [
//   //       DataCell(Text(element.symptoms)),
//   //       DataCell(Text(element.doctor_id)),
//   //       DataCell(Text(element.date)),
//   //     ]));
//   //   });

//   //   return rows;
//   // }
// }
