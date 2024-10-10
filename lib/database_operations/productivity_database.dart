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
        isComplete: taskSchedule.isComplete);

    //adding the task to the database
    await isar.writeTxn(() => isar.taskSchedules.put(task));
  }

  // read  a task
  Future<void> readTask() async {
    // fetch all habits from the db
    List<TaskSchedule> tasks = await isar.taskSchedules.where().findAll();

    //give the list of tasks to the List of tasks
    this.tasks.clear();
    this.tasks.addAll(tasks);

    //notify the listeners that the list has been updated
    notifyListeners();
  }

  // give the current
}
