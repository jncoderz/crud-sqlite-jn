import 'package:flutter/material.dart';
import 'package:sqlite_test/helper/db_helper.dart';
import 'package:sqlite_test/screens/home_screen.dart';


void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
   DatabaseHelper.instance.db;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Student Record",
      home: HomeScreen(),
    );
  }
}


 