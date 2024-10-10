import 'package:isar/isar.dart';

part "task.g.dart";
// class acting as a model for TaskSchedule

@Collection()
class TaskSchedule {
  // the id for every schedule.
  Id id = Isar.autoIncrement;

  // the task title
  final String title;

  //category
  final String category;

  // time and date for the task
  final DateTime dateAndTime;

  //completed or not
  final bool isComplete;

  //completed days
  List<DateTime> completedDays = [];

  TaskSchedule(
      {required this.title,
      required this.category,
      required this.dateAndTime,
      required this.isComplete});
}
