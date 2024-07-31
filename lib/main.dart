import 'package:expense_tracker/database.dart';
import 'package:expense_tracker/pages/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  initDatabase();

  runApp(const MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(
        title: 'Expanse tracker',
      ),
    );
  }
}
