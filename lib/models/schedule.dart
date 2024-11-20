import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part "schedule.g.dart";

@Collection()
class ScheduleItem {
  Id id = Isar.autoIncrement;
  String title;
  DateTime dateTime;
  String description;
  List<bool> daysOfWeek;

  ScheduleItem({
    required this.title,
    required this.dateTime,
    required this.description,
    required this.daysOfWeek,
  });

  ScheduleItem copyWith({
    int? id,
    String? title,
    DateTime? dateTime,
    String? description,
    List<bool>? daysOfWeek,
  }) {
    return ScheduleItem(
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    );
  }
}
