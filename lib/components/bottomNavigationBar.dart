import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Bottomnavigationbar extends StatefulWidget {
  final void Function(int) onTabChange;
  const Bottomnavigationbar({super.key, required this.onTabChange});

  @override
  State<Bottomnavigationbar> createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: GNav(
          backgroundColor: Color(0xff85A389),
          //tabBackgroundColor: const Color(0xff85A389),
          color: Colors.black,
          activeColor: Colors.white,
          onTabChange: (value) => widget.onTabChange(value),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: " Home",
            ),
            GButton(
              icon: Icons.list,
              text: " Tasks",
            ),
            GButton(
              icon: Icons.add_alarm,
              text: " Schedule",
            ),
            GButton(
              icon: Icons.timelapse,
              text: " Pomodoro",
            ),
            GButton(
              icon: Icons.settings,
              text: " Settings",
            ),
          ]),
    );
  }
}
