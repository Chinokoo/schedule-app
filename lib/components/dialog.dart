import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:rosemary_app/components/dropdown-formfield.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  // the value for dropdown menu.
  Widget? value;
  //Storing thevalue of picked date and time
  DateTime? pickedDate;

  //list of task categories
  final List<Widget> taskCategories = [
    const Text(
      "Critical",
      style: TextStyle(color: Colors.red),
    ),
    const Text(
      "High",
      style: TextStyle(color: Colors.orange),
    ),
    const Text(
      "Medium",
      style: TextStyle(color: Colors.yellow),
    ),
    const Text(
      "Low",
      style: TextStyle(color: Colors.lightGreen),
    )
  ];

  // selected date and time.
  void selectDateTime() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable days before today
        return dateTime
            .isAfter(DateTime.now().subtract(const Duration(days: 1)));
      },
    );

    if (dateTime != null) {
      setState(() {
        pickedDate = dateTime;
      });
      print("Picked date: $pickedDate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text(
        'Create Task',
        style: TextStyle(
            color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),
      )),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            // Text Field for task title
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(8)),
                child: const TextField(
                    decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Task Title",
                  hintStyle: TextStyle(color: Colors.lightGreen),
                ))),
            // sized box for spacing
            const SizedBox(height: 20),
            // Dropdown for task category
            DropdownField(
              taskCategories: taskCategories,
              value: value,
            ),

            // sized box for spacing
            const SizedBox(height: 20),
            // pick date and time for task
            dateTimePicker(),
          ],
        ),
      ),
      actions: [
        //create task button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.green,
          ),
          child: const Text(
            "Create",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),

        //the cancel button
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.red,
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  //picked date and time function
  Widget dateTimePicker() {
    return InkWell(
        onTap: selectDateTime,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(8)),
          child: pickedDate != null
              ? Text(
                  'Selected Date: ${DateFormat('MMM d, y HH:mm').format(pickedDate!)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              : const Text("Pick Date and Time"),
        ));
  }
}
