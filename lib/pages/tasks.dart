import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/components/dialog.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/models/task.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  void showDialogBox() {
    showDialog(context: context, builder: (context) => const DialogBox())
        .then((_) {
      setState(() {
        Provider.of<ProductivityDatabase>(context, listen: false).readTask();
      });
    });
  }

  //init state
  @override
  void initState() {
    super.initState();
    readTasks();
  }

  //read and display all notes
  void readTasks() {
    //read all tasks from the database
    Provider.of<ProductivityDatabase>(context, listen: false).readTask();
  }

  @override
  Widget build(BuildContext context) {
    // continuos watch of the database
    final productivityDatabase = context.watch<ProductivityDatabase>();

    // current tasks list
    List<TaskSchedule> AvailableTasks = productivityDatabase.tasks;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: AvailableTasks.length,
                itemBuilder: (context, index) {
                  // get a single task.
                  final task = AvailableTasks[index];
                  DateTime time = task.dateAndTime;
                  return ListTile(
                    leading: SizedBox(
                      height: 10,
                      width: 10,
                      child: CheckboxListTile(
                          value: task.isComplete,
                          onChanged: (bool? newValue) {
                            setState(() {
                              task.isComplete = newValue ?? false;
                            });
                          }),
                    ),
                    title: Text(task.title),
                    subtitle: Text(
                        '${task.category} @ ${time.hour}:${time.minute} on ${time.day}/${time.month}/${time.year}'),
                    trailing: Icon(Icons.more_horiz_rounded),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff85A389),
          onPressed: showDialogBox,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
