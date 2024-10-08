import 'package:flutter/material.dart';
import 'package:rosemary_app/components/dialog.dart';
//import 'package:rosemary_app/pages/create_task.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  void showDialogBox() {
    showDialog(context: context, builder: (context) => const DialogBox());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Tasks.'),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff85A389),
          onPressed: showDialogBox,
          //() => Navigator.push(context,
          //  MaterialPageRoute(builder: (context) => const CreateTask())),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
