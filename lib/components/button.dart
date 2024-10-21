import 'package:flutter/material.dart';

class ScheduleButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color color;
  final String text;
  const ScheduleButton(
      {super.key, required this.color, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          )),
        ));
  }
}
