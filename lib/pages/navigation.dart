import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/components/bottomNavigationBar.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/pages/tasks.dart';
import 'package:rosemary_app/pages/homepage.dart';
import 'package:rosemary_app/pages/pomodoro.dart';
import 'package:rosemary_app/pages/settings.dart';

class NavigatePages extends StatefulWidget {
  const NavigatePages({super.key});

  @override
  State<NavigatePages> createState() => _NavigatePagesState();
}

class _NavigatePagesState extends State<NavigatePages> {
  int selectedIndex = 0;

  //List for the bottom navigation bar items
  final List<Widget> _pages = [
    const Homepage(),
    const AllTaskPage(),
    PomodoroPage(),
    const SettingsPage(),
  ];

  //navigate bottom navigation bar
  void navigateToPage(int index) {
    setState(() {
      Provider.of<ProductivityDatabase>(context, listen: false).readTask();
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[selectedIndex],
        bottomNavigationBar:
            Bottomnavigationbar(onTabChange: (index) => navigateToPage(index)));
  }
}
