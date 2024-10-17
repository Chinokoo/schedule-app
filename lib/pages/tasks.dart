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

    return Scaffold(
      body: Consumer<ProductivityDatabase>(
        builder: (context, productivityDatabase, child) {
          // current tasks list
          List<TaskSchedule> AvailableTasks = productivityDatabase.tasks;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: AvailableTasks.length,
                    itemBuilder: (context, index) {
                      // get a single task.
                      final task = AvailableTasks[index];
                      DateTime time = task.dateAndTime;
                      return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff85A389),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(children: [
                            Row(
                              children: [
                                Text(task.title,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color.fromARGB(255, 8, 77, 17),
                                        fontWeight: FontWeight.bold)),
                                const Spacer(),
                                Text(
                                    "${time.hour}:${time.minute} ${time.day}-${time.month}-${time.year}"),
                              ],
                            ),
                            const Divider(
                              color: Color(0xff85A389),
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          activeColor: Color(0xff85A389),
                                          shape: const CircleBorder(
                                              side: BorderSide()),
                                          value: task.isComplete,
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              task.isComplete =
                                                  newValue ?? false;
                                            });
                                          }),
                                      const Text("Completed"),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          shape: const CircleBorder(
                                              side: BorderSide()),
                                          value: task.isComplete,
                                          onChanged: (value) {}),
                                      const Text("In Progress"),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: MaterialButton(
                                    color: const Color(0xff85A389),
                                    onPressed: () {},
                                    child: const Text(
                                      "Start",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ]));
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
