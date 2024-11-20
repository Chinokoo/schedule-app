import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:rosemary_app/models/schedule.dart";

class ScheduleItemCard extends StatelessWidget {
  final SlidableActionCallback deleteSchedule;
  final ScheduleItem item;
  final List<String> _daysOfWeek = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  ScheduleItemCard({Key? key, required this.item, required this.deleteSchedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String selectedDays = item.daysOfWeek
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => _daysOfWeek[entry.key])
        .join(', ');

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: deleteSchedule,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Delete",
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xff85A389),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: const Icon(
              Icons.schedule,
              color: Colors.white,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.description,
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Days : $selectedDays',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            trailing: Text(
              '${item.dateTime.hour}:${item.dateTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }
}
