import 'package:flutter/material.dart';
import 'package:intelligent_health_consultant/add_appointment.dart';
import 'package:intelligent_health_consultant/Modals/Doctor.dart';

class Profile extends StatefulWidget {
  final Doctor doctor;
  const Profile({Key? key, required this.doctor}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  var tween = Tween<double>(begin: 0, end: 20);
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _animation = tween.animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });

    _animationController.fling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("data"),
        leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_outlined)),
      ),
      body: ListView(
        children: [
          Card(
            elevation: _animation.value,
            margin: const EdgeInsets.all(40),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.37,
              decoration: const BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 20),
                    child: Text(
                      widget.doctor.name,
                      style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 30),
                    child: Text(
                      widget.doctor.qualification,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[700],
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [Text('Email : ${widget.doctor.email}')],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 40, left: 40),
                    //  height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddAppointment(doctor: widget.doctor)));
                        },
                        child: const Text(
                          'Get Appoitment',
                          style: TextStyle(),
                        )),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
