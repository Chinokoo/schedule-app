import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rosemary_app/models/task.dart';

class ProductivityDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I T I A L I Z E   D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TaskScheduleSchema],
      directory: dir.path,
    );
  }

  // list of Tasks
  final List<TaskSchedule> tasks = [];

  // creating the first task
  Future<void> createTask(TaskSchedule taskSchedule) async {
    // creating a new task
    final TaskSchedule task = TaskSchedule(
        title: taskSchedule.title,
        category: taskSchedule.category,
        dateAndTime: taskSchedule.dateAndTime,
        createdAt: DateTime.now(),
        isInProgress: false,
        isComplete: taskSchedule.isComplete);

    //adding the task to the database
    await isar.writeTxn(() => isar.taskSchedules.put(task));
    notifyListeners();
  }

  // read  a task
  Future<void> readTask() async {
    // fetch all tasks from the db
    List<TaskSchedule> fetchedTasks =
        await isar.taskSchedules.where().findAll();

    // clear the existing list and add all fetched tasks
    tasks.clear();
    tasks.addAll(fetchedTasks);

    // sort the tasks by created date in descending order
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // notify listeners that the list has been updated
    notifyListeners();
  }
}
