import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/components/button.dart';
import 'package:rosemary_app/components/schedule_card.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/models/schedule.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  //list of schedules
  DateTime selectedDate = DateTime.now();

  //init state
  @override
  void initState() {
    super.initState();
    readSchedules();
    setState(() {});
  }

  showDeleteDialog(context, int id) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Delete",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              actions: [
                Row(
                  children: [
                    ScheduleButton(
                        color: Colors.red,
                        text: "Delete",
                        onTap: () {
                          Navigator.pop(context);
                          //productivityDatabase.deleteSchedule(id);
                          Provider.of<ProductivityDatabase>(context,
                                  listen: false)
                              .deleteSchedule(id);
                          //force the immediate UI refresh
                          Provider.of<ProductivityDatabase>(context,
                                  listen: false)
                              .readSchedule();
                        }),
                    ScheduleButton(
                      color: const Color(0xff85A389),
                      text: "Cancel",
                      onTap: () => Navigator.pop(context),
                    )
                  ],
                )
              ],
            ));
  }

  //read and display all notes
  void readSchedules() {
    //read all tasks from the database
    Provider.of<ProductivityDatabase>(context, listen: false).readSchedule();
  }

  //productivity
  ProductivityDatabase productivityDatabase = ProductivityDatabase();

  @override
  Widget build(BuildContext context) {
    // First we get the schedules filtered by the selected date from EasyDateTimeline
    List<ScheduleItem> dateFilteredSchedules = [];
    // Then we filter those schedules by weekday
    final weekdayFilteredSchedules = dateFilteredSchedules.where((schedule) {
      return schedule.dateTime.weekday == selectedDate.weekday;
    }).toList();
    print("Filtered schedules: ${weekdayFilteredSchedules.length}");

    return Scaffold(
      body: Consumer<ProductivityDatabase>(
          builder: (context, productivityDatabase, child) {
        List<ScheduleItem> schedules = productivityDatabase.schedules;
        // Filter schedules based on selected date's weekday
        schedules = schedules.where((schedule) {
          return schedule.daysOfWeek[selectedDate.weekday % 7];
        }).toList();

        return Column(
          children: [
            EasyDateTimeLine(
                initialDate: DateTime.now(),
                activeColor: const Color(0xff85A389),
                onDateChange: (newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                }),
            schedules.isEmpty
                ? Center(
                    child: Text("No Schedules."),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          //ScheduleItem schedule = schedules[index];
                          final schedule = schedules[index];

                          return ScheduleItemCard(
                            item: schedule,
                            deleteSchedule: (BuildContext context) =>
                                showDeleteDialog(
                              context,
                              schedule.id,
                            ),
                          );
                        }),
                  ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff85A389),
        onPressed: () => _showAddScheduleDialog(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Schedule Item',
          style: TextStyle(
              color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        content: AddScheduleForm(
          onSubmit: (ScheduleItem item) {
            productivityDatabase.createSchedule(item);
            readSchedules();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class AddScheduleForm extends StatefulWidget {
  final Function(ScheduleItem) onSubmit;

  const AddScheduleForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddScheduleForm> createState() => _AddScheduleFormState();
}

class _AddScheduleFormState extends State<AddScheduleForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  List<bool> _selectedDays = List.filled(7, false);
  final _daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //title
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Task Title",
                    hintStyle: TextStyle(color: Colors.lightGreen),
                  ))),
          //sized box for spacing
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                  minLines: 3,
                  maxLines: 4,
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Task Description",
                    hintStyle: TextStyle(color: Colors.lightGreen),
                  ))),
          const SizedBox(height: 10),
          Wrap(
            spacing: 5.0,
            children: List.generate(7, (index) {
              return FilterChip(
                label: Text(_daysOfWeek[index]),
                selected: _selectedDays[index],
                onSelected: (bool selected) {
                  setState(() {
                    _selectedDays[index] = selected;
                  });
                },
              );
            }),
          ),
          TextButton(
            onPressed: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedTime),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: const TimePickerThemeData(
                          backgroundColor: Colors.white,
                          dialBackgroundColor: Colors.white,
                          dialHandColor: Colors.green,
                          dialTextColor: Colors.black,
                          hourMinuteTextColor: Colors.white,
                          hourMinuteColor: Colors.green,
                          dayPeriodTextColor: Colors.white,
                          dayPeriodColor: Colors.green,
                        ),
                      ),
                      child: child!,
                    );
                  });
              if (pickedTime != null) {
                setState(() {
                  _selectedTime = DateTime(
                    _selectedTime.year,
                    _selectedTime.month,
                    _selectedTime.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                });
              }
            },
            child: Text(
              'Select Time: ${_selectedTime.hour}:${_selectedTime.minute}',
              style: const TextStyle(color: Colors.green),
            ),
          ),

          //create task button
          InkWell(
            onTap: () {
              if (_titleController.text.isNotEmpty &&
                  _descriptionController.text.isNotEmpty &&
                  _selectedDays.isNotEmpty) {
                widget.onSubmit(ScheduleItem(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dateTime: _selectedTime,
                  daysOfWeek: _selectedDays,
                ));
                // showing a toast message to confirm the task creation
                Fluttertoast.showToast(
                    msg: "Created Succesfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                Fluttertoast.showToast(
                    msg: "Fill all fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),
              child: const Text(
                "Create Schedule",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
