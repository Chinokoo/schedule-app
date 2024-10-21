import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rosemary_app/components/button.dart';

class TaskContainer extends StatefulWidget {
  String title, description;
  void Function(BuildContext) editTask, deleteTask;
  VoidCallback? onTap;
  bool isComplete, isInProgress;
  DateTime date;
  final Function(bool isComplete, bool isInProgress) onStatusChange;
  TaskContainer({
    super.key,
    required this.editTask,
    required this.deleteTask,
    required this.date,
    required this.title,
    required this.description,
    required this.isComplete,
    required this.isInProgress,
    required this.onTap,
    required this.onStatusChange,
  });

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(motion: ScrollMotion(), children: [
        //edit button
        SlidableAction(
          onPressed: widget.editTask,
          backgroundColor: Color(0xff85A389),
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: 'Edit',
        ),
        //edit button
        SlidableAction(
          onPressed: widget.deleteTask,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        )
      ]),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff85A389),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 8, 77, 17),
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(widget.date),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color(0xff85A389),
            ),
            Text(widget.description),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.isComplete
                          ? const Color(0xff85A389)
                          : Colors.transparent),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: const Color(0xff85A389),
                          shape: const CircleBorder(side: BorderSide()),
                          value: widget.isComplete,
                          onChanged: (bool? newValue) {
                            setState(() {
                              widget.isComplete = newValue ?? false;
                              if (widget.isComplete) {
                                widget.isInProgress = false;
                              }
                              widget.onStatusChange(
                                  widget.isComplete, widget.isInProgress);
                            });
                          }),
                      Text(
                        "Completed",
                        style: TextStyle(
                          color: widget.isComplete
                              ? Colors.white
                              : const Color(0xff85A389),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: widget.isInProgress
                          ? const Color(0xff85A389)
                          : Colors.transparent),
                  child: Row(
                    children: [
                      Checkbox(
                          activeColor: const Color(0xff85A389),
                          shape: const CircleBorder(side: BorderSide()),
                          value: widget.isInProgress,
                          onChanged: (bool? newValue) {
                            widget.isInProgress = newValue ?? false;
                            //if (widget.isInProgress) {
                            //widget.isComplete = false;
                            //}
                            widget.onStatusChange(
                                widget.isComplete, widget.isInProgress);
                          }),
                      Text(
                        "In Progress",
                        style: TextStyle(
                            color: widget.isInProgress
                                ? Colors.white
                                : const Color(0xff85A389)),
                      ),
                    ],
                  ),
                ),
                ScheduleButton(
                    color: const Color(0xff85A389),
                    text: "Start",
                    onTap: widget.onTap)
              ],
            )
          ],
        ),
      ),
    );
  }
}
