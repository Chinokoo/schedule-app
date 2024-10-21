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

  //task description
  String description;

  //completed or not
  bool isComplete;

  //in progress or not.
  bool isInProgress;
  //created at
  @Index(type: IndexType.value)
  final DateTime createdAt;

  TaskSchedule(
      {required this.title,
      required this.category,
      required this.dateAndTime,
      required this.description,
      required this.createdAt,
      required this.isInProgress,
      required this.isComplete});

  // Add this copyWith method
  TaskSchedule copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dateAndTime,
    bool? isComplete,
    bool? isInProgress,
  }) {
    return TaskSchedule(
        title: title ?? this.title,
        category: category,
        description: description ?? this.description,
        dateAndTime: dateAndTime ?? this.dateAndTime,
        isComplete: isComplete ?? this.isComplete,
        isInProgress: isInProgress ?? this.isInProgress,
        createdAt: createdAt);
  }
}
