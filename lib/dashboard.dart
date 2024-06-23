import 'package:flutter/material.dart';
import 'package:intelligent_health_consultant/appointments.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:intelligent_health_consultant/all_doctors.dart';
import 'package:intelligent_health_consultant/disease_alert.dart';
import 'package:intelligent_health_consultant/Modals/user.dart';
import 'package:intelligent_health_consultant/multi_select_dialog_item.dart';
import 'package:intelligent_health_consultant/doctors.dart';
import 'package:intelligent_health_consultant/services/firbase_services.dart';

import 'add_doctor.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color color = Colors.green;
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  final FirebaseServices _firebaseServices = FirebaseServices();
  UserModel? user;
  bool shouldpop = false;
  String _role = '';

  AppBar appbar = AppBar(
    title: const Text(
      'Health Consultant',
      style: TextStyle(color: Colors.black, fontSize: 22),
    ),
    backgroundColor: Colors.blue,
    actions: const [
      Padding(
        padding: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.notifications_outlined,
          color: Colors.green,
          size: 30,
        ),
      ),
    ],
  );

  @override
  void initState() {
    checkRole();
    super.initState();
  }

  checkRole() async {
    await Future.delayed(const Duration(seconds: 3));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = await _firebaseServices.getUserByUid(prefs.getString('uid') ?? '');
    setState(() {
      if (user == null) {
        _role = '';
      } else {
        if (user!.role == 'p') _role = 'patient';
        if (user!.role == 'd') _role = 'doctor';
        if (user!.role == 'admin') _role = 'admin';
      }
    });
  }

  var selectedSymtoms = <int>{};
  var allSymptoms = {
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
        } else if (selectedValues.isNotEmpty && selectedValues.length <= 4) {
          diseaseAlert(
              "Your Disease is MINOR COVID according to your symptoms.");
        } else if (selectedValues.isNotEmpty && selectedValues.length <= 8) {
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
    }
  }

  void diseaseAlert(String dis) {
    showAlertDialog(context, dis);
  }

  @override
  Widget build(BuildContext context) {
    Drawer drawer = Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage('assets/drawer.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: ListTile(
              title: GestureDetector(
                onTap: () => _firebaseServices.logOut(context),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.indigo, fontSize: 15),
                ),
              ),
            ),
          ),
          const ListTile(
            title: Text(
              'Change Location',
              style: TextStyle(color: Colors.indigo, fontSize: 15),
            ),
          ),
        ],
      ),
    );

    // if (widget.loginResponse.email == 'admin@mail.com') {
    if (_role == 'admin') {
      return WillPopScope(
        onWillPop: () async {
          globalKey.currentState!.openDrawer();
          return shouldpop;
        },
        child: Scaffold(
          appBar: appbar,
          drawer: drawer,
          body: Container(
            color: Colors.blue[50],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddDoctor()));
                        },
                        child: const Text('Add Doctor')),
                  ),
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AllDoctors()));
                        },
                        child: const Text('All Doctors')),
                  ),
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: ElevatedButton(
                        onPressed: () => _firebaseServices.logOut(context),
                        child: const Text('Log Out')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (_role == 'doctor') {
      return WillPopScope(
        onWillPop: () async {
          globalKey.currentState!.openDrawer();
          return shouldpop;
        },
        child: Scaffold(
            appBar: appbar,
            drawer: drawer,
            body: Column(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/health.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Appointments(
                              userId: user!.uid!,
                              role: _role,
                            )));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone_iphone_outlined,
                        color: color,
                        size: 22,
                      ),
                      title: Text(
                        'Your Appointment Dr Edition',
                        style: TextStyle(color: color, fontSize: 18),
                      ),
                      trailing: (Icon(
                        Icons.arrow_forward_ios,
                        color: color,
                        size: 20,
                      )),
                    ),
                  ),
                ),
              ),
            ])),
      );
    } else if (_role == 'patient') {
      return WillPopScope(
        onWillPop: () async {
          globalKey.currentState!.openDrawer();
          return shouldpop;
        },
        child: Scaffold(
          key: globalKey,
          appBar: appbar,
          drawer: drawer,
          body: ListView(
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.20,
              //   width: MediaQuery.of(context).size.width,
              //   margin: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     image: const DecorationImage(
              //       image: AssetImage('assets/health.jpg'),
              //       fit: BoxFit.cover,
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              // ),
              Card(
                elevation: 2,
                margin: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    _firebaseServices.fetchAppointments(user!.uid!, _role);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Appointments(
                              userId: user!.uid!,
                              role: _role,
                            )));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone_iphone_outlined,
                        color: color,
                        size: 22,
                      ),
                      title: Text(
                        'Your Appointment',
                        style: TextStyle(color: color, fontSize: 18),
                      ),
                      trailing: (Icon(
                        Icons.arrow_forward_ios,
                        color: color,
                        size: 20,
                      )),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Doctors()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(
                        Icons.search,
                        color: color,
                        size: 25,
                      ),
                      title: Text(
                        'Doctors',
                        style: TextStyle(color: color, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              Card(
                elevation: 10,
                margin: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    _showMultiSelect(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(
                        Icons.search,
                        color: color,
                        size: 25,
                      ),
                      title: Text(
                        'Symptoms',
                        style: TextStyle(color: color, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }
  }
}
