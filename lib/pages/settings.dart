import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Center(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Color(
                    0xff85A389,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About The App",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Text(
                    "This Scheduler app helps you organize your tasks, schediles with daily reminders and calender intergration, and user-friendly interface, its designed to boost productivity and help you stay on top of your schedule.",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    textAlign: TextAlign.left,
                    "Features include :",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),

                  // Add this after the "Features include:" Text widget
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Expanded(
                              child: Text(
                                "Task Management",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Expanded(
                              child: Text(
                                "Calendar Integration",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Expanded(
                              child: Text(
                                "Daily Reminders",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
