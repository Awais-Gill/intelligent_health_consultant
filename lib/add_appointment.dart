import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intelligent_health_consultant/Modals/Doctor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:intelligent_health_consultant/Modals/user.dart';
import 'package:intelligent_health_consultant/multi_select_dialog_item.dart';
import 'package:intelligent_health_consultant/services/firbase_services.dart';

class AddAppointment extends StatefulWidget {
  // final LoginResponse loginResponse;
  final Doctor doctor;

  const AddAppointment({Key? key, required this.doctor}) : super(key: key);

  @override
  State<AddAppointment> createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  final symptomsController = TextEditingController();
  final dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final FocusNode _focus = FocusNode();
  var selectedSymtoms = <int>{};
  Map<int, String> allSymptoms = {
    1: 'Fever',
    2: 'Cough',
    3: 'Tiredness',
    4: 'Loss of taste or smell',
    5: 'Sore throat',
    6: 'Headache',
    7: 'Aches and pains',
    8: 'Diarrhoea'
  };

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[
      const MultiSelectDialogItem(1, 'Fever'),
      const MultiSelectDialogItem(2, 'Cough'),
      const MultiSelectDialogItem(3, 'Tiredness'),
      const MultiSelectDialogItem(4, 'Loss of taste or smell'),
      const MultiSelectDialogItem(5, 'Sore throat'),
      const MultiSelectDialogItem(6, 'Headache'),
      const MultiSelectDialogItem(7, 'Aches and pains'),
      const MultiSelectDialogItem(8, 'Diarrhoea'),
    ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: selectedSymtoms,
        );
      },
    );

    if (selectedValues != null) {
      print(selectedValues);
      if (selectedValues.isNotEmpty) {
        if (selectedValues.isNotEmpty && selectedValues.length <= 2) {
          diseaseAlert("You have not COVID symptoms.Likely you have fever.");
        } else if ((selectedValues.isNotEmpty && selectedValues.length <= 4)) {
          diseaseAlert(
              "Your Disease is MINOR COVID according to your symptoms.");
        } else if ((selectedValues.isNotEmpty && selectedValues.length <= 8)) {
          diseaseAlert("Your Disease is COVID according to your symptoms.");
        }
      } else {
        diseaseAlert("You have not any symptoms of COVID");
      }

      selectedSymtoms = selectedValues;
      var text = "";
      var allKeys = allSymptoms.keys;
      var index = 0;
      for (var element in allKeys) {
        if (selectedSymtoms.contains(element)) {
          var value = allSymptoms[element];
          print(value);
          if (index == 0) {
            text = value!;
          } else {
            text = "$text , $value";
          }
          index = index + 1;
        }
      }
      symptomsController.text = text;
    }
  }

  void diseaseAlert(String dis) {
    // showAlertDialog(context, dis);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      final f = DateFormat('dd MMM, yyyy');
      print(f.format(picked).toString());
      dateController.text = f.format(picked).toString();
      selectedDate = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Appointment")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showMultiSelect(context);
                },
                child: IgnorePointer(
                  child: TextField(
                    readOnly: true,
                    focusNode: _focus,
                    controller: symptomsController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Symptoms',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _selectDate(context),
                child: IgnorePointer(
                  child: TextField(
                    readOnly: true,
                    controller: dateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date',
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  UserModel? patient = await _firebaseServices
                      .getUserByUid(prefs.getString('uid') ?? '');

                  await _firebaseServices
                      .addNewAppointment(patient!, widget.doctor,
                          dateController.text, symptomsController.text)
                      .then((value) {
                    if (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Appointment Added')));
                      Navigator.of(context).pop();
                    }
                  });
                },
                child: const Text('Get Appointment.'))
          ],
        ),
      ),
    );
  }
}
