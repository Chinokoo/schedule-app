import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final List<Widget> taskCategories;
  Widget? value;
  DropdownField({super.key, required this.taskCategories, this.value});

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Widget>(
          items: widget.taskCategories
              .map((taskCategory) => DropdownMenuItem(
                    value: taskCategory,
                    child: taskCategory,
                  ))
              .toList(),
          onChanged: ((Widget? newValue) => setState(() {
                widget.value = newValue;
              })),
          hint: const Text(" Select a Task Category"),
          iconSize: 36,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.green,
          ),
          value: widget.value,
        ),
      ),
    );
  }
}
