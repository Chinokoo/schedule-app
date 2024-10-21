import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/models/task.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    readTasks();
  }

  void readTasks() {
    Provider.of<ProductivityDatabase>(context, listen: false).readTask();
  }

  //selected date
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // continuos watch of the database
    final productivityDatabase = context.watch<ProductivityDatabase>();

    // current tasks list
    List<TaskSchedule> availableTasks = productivityDatabase.tasks;

    //list of filtered tasks
    List<TaskSchedule> filteredTasks = availableTasks.where((task) {
      return task.dateAndTime.year == selectedDate.year &&
          task.dateAndTime.month == selectedDate.month &&
          task.dateAndTime.day == selectedDate.day;
    }).toList();

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Stack(children: [
        // container for the date timeline...
        Container(
          child: Column(
            children: [
              EasyDateTimeLine(
                initialDate: DateTime.now(),
                activeColor: const Color(0xff85A389),
                onDateChange: (newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
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
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      // get a single task.
                      final task = filteredTasks[index];
                      DateTime time = task.dateAndTime;
                      return ListTile(
                        leading: Text('${time.hour}:${time.minute}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        title: Text(
                          task.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                            task.isComplete
                                ? "Completed"
                                : (task.isInProgress
                                    ? "In Progress"
                                    : (task.dateAndTime.isAfter(DateTime.now())
                                        ? "Upcoming"
                                        : "Pending")),
                            style: const TextStyle(color: Colors.white)),
                        trailing: Text(
                          task.category,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ])),
    ));
  }
}
