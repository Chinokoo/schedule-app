import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/components/button.dart';
import 'package:rosemary_app/components/dialog.dart';
import 'package:rosemary_app/components/task_container.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/models/task.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  //alert dialog box for creating a task
  void showDialogBox() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(),
    );
  }

  // Alert dialog box for deleting the task
  void showDeleteDialogBox(TaskSchedule task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete This Task",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              ScheduleButton(
                color: Colors.red,
                text: "Delete",
                onTap: () {
                  context.read<ProductivityDatabase>().deleteTask(task.id);
                  Navigator.pop(context);
                },
              ),
              ScheduleButton(
                color: const Color(0xff85A389),
                text: "Cancel",
                onTap: () => Navigator.pop(context),
              )
            ],
          )
        ],
      ),
    );
  }

//alert dialog box for editing the task
  void showEditDialogBox(TaskSchedule task) {
    showDialog(
        context: context,
        builder: (context) => DialogBox(
              updateTask: task,
            ));
    Provider.of<ProductivityDatabase>(context, listen: false).readTask();
  }

  //alert dialog box for starting the task
  void showStartDialogBox(TaskSchedule task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Start this task.",
          style:
              TextStyle(color: Color(0xff85A389), fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              ScheduleButton(
                color: const Color(0xff85A389),
                text: "Start",
                onTap: () {
                  context.read<ProductivityDatabase>().updateTaskProgress(
                      task.id,
                      isInProgress: true,
                      isComplete: false);
                  Navigator.pop(context);
                  setState(() {
                    task.isInProgress = true;
                  });
                },
              ),
              ScheduleButton(
                color: Colors.red,
                text: "Cancel",
                onTap: () => Navigator.pop(context),
              )
            ],
          )
        ],
      ),
    );
  }

  //updating the task status
  void updateTaskStatus(int taskId, bool isComplete, bool isInProgress) {
    context.read<ProductivityDatabase>().updateTaskProgress(taskId,
        isInProgress: isInProgress, isComplete: isComplete);
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

    return Scaffold(
      body: Consumer<ProductivityDatabase>(
        builder: (context, productivityDatabase, child) {
          // current tasks list
          List<TaskSchedule> AvailableTasks = productivityDatabase.tasks;

          return AvailableTasks.isEmpty
              ? const Center(
                  child: Text("No Schedules Available..."),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: AvailableTasks.length,
                          itemBuilder: (context, index) {
                            // get a single task.
                            final task = AvailableTasks[index];
                            DateTime time = task.dateAndTime;
                            return TaskContainer(
                              date: time,
                              title: task.title,
                              description: task.description,
                              isComplete: task.isComplete,
                              isInProgress: task.isInProgress,
                              editTask: (context) => showEditDialogBox(task),
                              deleteTask: (context) =>
                                  showDeleteDialogBox(task),
                              onTap: () => showStartDialogBox(task),
                              onStatusChange: (isComplete, isInProgress) {
                                updateTaskStatus(
                                    task.id, isComplete, isInProgress);
                              },
                            );
                          }),
                    ),
                  ],
                );
        },
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
