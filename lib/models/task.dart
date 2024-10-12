import 'package:isar/isar.dart';

part "task.g.dart";
// class acting as a model for TaskSchedule

@Collection()
class TaskSchedule {
  // the id for every schedule.
  Id id = Isar.autoIncrement;

  // the task title
  String title;

  //category
  String category;

  // time and date for the task
  DateTime dateAndTime;

  //completed or not
  bool isComplete;

  //in progress or not.
  bool isInProgress;
  //completed days
  List<DateTime> completedDays = [];
  //created at
  @Index(type: IndexType.value)
  final DateTime createdAt;

  TaskSchedule(
      {required this.title,
      required this.category,
      required this.dateAndTime,
      required this.createdAt,
      required this.isInProgress,
      required this.isComplete});
}
