import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rosemary_app/models/schedule.dart';
import 'package:rosemary_app/models/task.dart';

class ProductivityDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I T I A L I Z E   D A T A B A S E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TaskScheduleSchema, ScheduleItemSchema],
      directory: dir.path,
    );
  }

  //* list of Tasks
  final List<TaskSchedule> tasks = [];
  //list of schedules
  final List<ScheduleItem> schedules = [];

  //* creating the first task
  Future<void> createTask(TaskSchedule taskSchedule) async {
    // creating a new task
    final TaskSchedule task = TaskSchedule(
        title: taskSchedule.title,
        category: taskSchedule.category,
        description: taskSchedule.description,
        dateAndTime: taskSchedule.dateAndTime,
        createdAt: DateTime.now(),
        isInProgress: false,
        isComplete: taskSchedule.isComplete);

    //adding the task to the database
    await isar.writeTxn(() => isar.taskSchedules.put(task));
    notifyListeners();
  }

  //* creating the first task
  Future<void> createSchedule(ScheduleItem scheduleItem) async {
    // creating a new schedule
    final ScheduleItem schedule = ScheduleItem(
        title: scheduleItem.title,
        dateTime: scheduleItem.dateTime,
        description: scheduleItem.description,
        daysOfWeek: scheduleItem.daysOfWeek);
    //adding the task to the database
    await isar.writeTxn(() => isar.scheduleItems.put(schedule));
    notifyListeners();
  }

  //read a schedule
  Future<void> readSchedule() async {
    // fetch all tasks from the db
    List<ScheduleItem> fetchedSchedules =
        await isar.scheduleItems.where().findAll();

    // clear the existing list and add all fetched tasks
    schedules.clear();
    schedules.addAll(fetchedSchedules);

    // sort the tasks by created date in descending order
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // notify listeners that the list has been updated
    notifyListeners();
  }

  //* read  a task
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

  // read a completed task
  Future<List<TaskSchedule>> completedTask(
      bool isComplete, DateTime date) async {
    //fetch all habits from the database
    List<TaskSchedule> completedTasks =
        await isar.taskSchedules.filter().isCompleteEqualTo(true).findAll();

    return completedTasks;
  }

  //updating a task
  Future<void> updateTask(int id, TaskSchedule newTaskSchedule) async {
    //find the task with the given id.
    await isar.writeTxn(() async {
      final existingTask = await isar.taskSchedules.get(id);
      if (existingTask != null) {
        existingTask.title = newTaskSchedule.title;
        existingTask.category = newTaskSchedule.category;
        existingTask.description = newTaskSchedule.description;
        existingTask.dateAndTime = newTaskSchedule.dateAndTime;

        await isar.taskSchedules.put(existingTask);
      }
    });
    //re-read the tasks from the database
    await readTask();
  }

  //updating a task
  Future<void> updateSchedule(int id, ScheduleItem newScheduleItem) async {
    //find the task with the given id.
    await isar.writeTxn(() async {
      final existingSchedule = await isar.scheduleItems.get(id);
      if (existingSchedule != null) {
        existingSchedule.title = newScheduleItem.title;
        //existingSchedule.category = newScheduleItem.category;
        existingSchedule.description = newScheduleItem.description;
        existingSchedule.dateTime = newScheduleItem.dateTime;

        await isar.scheduleItems.put(existingSchedule);
      }
    });
    //re-read the tasks from the database
    await readSchedule();
  }

  //updating the progress status of a task
  Future<void> updateTaskProgress(int id,
      {required bool isInProgress, required bool isComplete}) async {
    await isar.writeTxn(() async {
      final task = await isar.taskSchedules.get(id);
      if (task != null) {
        task.isInProgress = isInProgress;
        task.isComplete = isComplete;
        await isar.taskSchedules.put(task);
      }
    });
    //re-read from the database
    await readTask();
  }

  //*deleting a task
  Future<void> deleteTask(int id) async {
    //perform the delete operation
    await isar.writeTxn(() async {
      await isar.taskSchedules.delete(id);
    });
    //re-read the tasks from the database
    await readTask();
  }

  //*deleting a schedule
  Future<void> deleteSchedule(int id) async {
    //perform the delete operation
    await isar.writeTxn(() async {
      await isar.scheduleItems.delete(id);
    });
    //re-read the tasks from the database
    await readSchedule();
  }
}
