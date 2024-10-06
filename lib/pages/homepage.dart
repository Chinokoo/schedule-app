import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            // container for the date timeline...
            Container(
              child: Column(
                children: [
                  EasyDateTimeLine(
                    initialDate: DateTime.now(),
                    activeColor: const Color(0xff85A389),
                  ),
                ],
              ),
            ),
            // Container that displays the tasks list.
            Container(
              margin: const EdgeInsets.only(top: 250),
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  color: Color(0xff85A389),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: const Center(
                child: Text(
                  "No Tasks yet...",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
