import 'package:flutter/material.dart';
import 'package:pretest/dbhelper.dart';
import 'package:pretest/myuser.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(const MyApp());
}

void init() async {
  await Dbhelper.instance.initDB();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User DB Demo',
      home: MyUser(),
    );
  }
}
