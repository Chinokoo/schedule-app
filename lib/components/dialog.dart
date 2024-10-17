import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/components/dropdown-formfield.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/models/task.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key});

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  //title
  TextEditingController titleController = TextEditingController();
  //description
  TextEditingController descController = TextEditingController();
  // iscomplete variable to check if task is completed or not.
  bool iscomplete = false;
  //loading
  bool isLoading = false;
  // the value for dropdown menu.
  Widget? value;
  //Storing thevalue of picked date and time
  DateTime? pickedDate;
  //for converting value to a string.
  String selectedCategory = "";

  //instance of TaskSchedule class to store the data of the task.
  TaskSchedule? taskSchedule;

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

  // function to get the text from the dropdown menu.
  String getWidgetText(Widget? widget) {
    if (widget is Text) {
      return widget.data ?? '';
    }
    return '';
  }

  //init state
  @override
  void initState() {
    Provider.of<ProductivityDatabase>(context, listen: false).readTask();
    super.initState();
  }

  void saveTask() {
    if (titleController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        selectedCategory.isNotEmpty &&
        pickedDate != null) {
      isLoading = true;
      //instance of Task class to store the data of the task.
      taskSchedule = TaskSchedule(
        title: titleController.text,
        category: selectedCategory,
        description: descController.text,
        isComplete: iscomplete,
        createdAt: DateTime.now(),
        isInProgress: false,
        dateAndTime: pickedDate!,
      );

      // Check if taskSchedule is not null before calling createTask
      if (taskSchedule != null) {
        //set the loading to false
        setState(() {
          //saving to the database
          context.read<ProductivityDatabase>().createTask(taskSchedule!);

          isLoading = false;
        });
        Provider.of<ProductivityDatabase>(context, listen: false).readTask();
        // showing a toast message to confirm the task creation
        Fluttertoast.showToast(
            msg: "Created Succesfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        //clearing the text fields
        Navigator.pop(context);
      }
    } else {
      Fluttertoast.showToast(
          msg: "fill all the fields!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // selected date and time.
  void selectDateTime() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      theme: customTheme,
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
      content: SingleChildScrollView(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              // Text Field for task title
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
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
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                    selectedCategory = getWidgetText(value);
                  });
                },
              ),
              // sized box for spacing
              const SizedBox(height: 20),

              // Text Field for task description
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                      controller: descController,
                      minLines: 3,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: "Enter Task Description",
                        hintStyle: TextStyle(color: Colors.lightGreen),
                      ))),

              // sized box for spacing
              const SizedBox(height: 20),
              // pick date and time for task
              dateTimePicker(),
            ],
          ),
        ),
      ),
      actions: [
        //create task button
        InkWell(
          onTap: saveTask,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green,
            ),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.green,
                  ))
                : const Text(
                    "Create",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
        ),

        //the cancel button
        InkWell(
          onTap: () {
            titleController.clear();
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

final customTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.green,
    onSurface: Colors.black,
  ),
  dialogBackgroundColor: Colors.white,
);
