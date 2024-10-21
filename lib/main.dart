import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rosemary_app/database_operations/productivity_database.dart';
import 'package:rosemary_app/pages/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
    );
  }
}
