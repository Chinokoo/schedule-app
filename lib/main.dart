import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/notifications/notification.dart';
import 'package:rosemary_app/pages/intro_page.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //intialized notificationService
  await NotificationService.init();
  tz.initializeTimeZones();

  //intializing the database
  await ProductivityDatabase.initialize();
  runApp(MultiProvider(
    providers: [
      //database provider
      ChangeNotifierProvider(create: (context) => ProductivityDatabase()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<ProductivityDatabase>();
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: IntroPage());
  }
}

// Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                   onPressed: () {
//                     NotificationService.showInstantNotification(
//                         "Instant Notifications",
//                         "This Shows an Instance Notification");
//                   },
//                   child: Text("instant Notification")),
//               ElevatedButton(
//                   onPressed: () {
//                     DateTime scheduleDate =
//                         DateTime.now().add(const Duration(seconds: 5));
//                     NotificationService.showScheduledNotification(
//                         "Scheduled Notification",
//                         "This notification is scheduled",
//                         scheduleDate);
//                   },
//                   child: Text("Scheduled  Notification")),
//             ],
//           ),
//         ),
//       ),