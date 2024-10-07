import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:rosemary_app/components/dropdown-formfield.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  // the value for dropdown menu.
  Widget? value;
  //Storing thevalue of picked date and time
  DateTime? pickedDate;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            const Center(
                child: Text(
              'Create Task',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )),
            // sized box for spacing
            const SizedBox(height: 20),

            // Text Field for task title
            const TextField(
                decoration: InputDecoration(
                    hintText: "Enter Task Title",
                    hintStyle: TextStyle(color: Colors.lightGreen),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff85A389), width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)))),
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
            // sized box for spacing
          ],
        ),
      ),
    ));
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
