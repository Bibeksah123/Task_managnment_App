import 'package:flutter/material.dart';
import 'package:task_managnment_app/screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Color.fromARGB(255, 169, 223, 236),
      debugShowCheckedModeBanner: false,
      title: 'Task App',
      home: SigninScreen(),
    );
  }
}
