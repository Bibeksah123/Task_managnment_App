import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_managnment_app/libraries.dart';
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
        color: Color.fromARGB(255, 60, 208, 245),
        debugShowCheckedModeBanner: false,
        title: 'Task App',
        home: Scaffold(
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomePage();
                  } else {
                    return SigninScreen();
                  }
                })));
  }
}
