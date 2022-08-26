// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_managnment_app/models/user_model.dart';
import 'package:task_managnment_app/screens/Taskdescription.dart';
import 'package:task_managnment_app/screens/signin.dart';
import 'package:task_managnment_app/screens/updateTask.dart';
import '../libraries.dart';

class HomePage extends StatefulWidget {
  final String? userId;
  final String? noteId;
  const HomePage({Key? key, this.userId, this.noteId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("usersId")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        loggedInUser = loggedInUser;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 162, 213, 247),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTask(userId: loggedInUser.uid),
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout,
                  color: Color.fromARGB(255, 66, 93, 247)))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('usersId')
            .doc(loggedInUser.uid)
            .collection('tasks')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: snapshot.data!.docs.map((document) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return NoteDescription(
                        userId: loggedInUser.uid!,
                        title: document['title'],
                        description: document['description'],
                        createdDate: document['createdDate'],
                        createdTime: document['createdTime'],
                      );
                    })));
                  },
                  child: Card(
                    elevation: 8.0,
                    color: Color.fromARGB(255, 152, 234, 248),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                              child: Image.asset("assets/images/header.jpg")),
                          iconColor: Colors.black,
                          title: Text(
                            document['title'],
                            style: const TextStyle(
                                color: Color.fromARGB(255, 146, 138, 250),
                                fontSize: 30.0),
                          ),
                          subtitle: Text(
                            document['description'],
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Color.fromARGB(255, 12, 12, 12)),
                          ),
                          isThreeLine: true,
                        ),
                        Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                    elevation: 3.0,
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => Updatetasks(
                                                    userId: loggedInUser.uid,
                                                    noteId: document.id,
                                                    title: document['title'],
                                                    description:
                                                        document['description'],
                                                    createdDate:
                                                        document['createdDate'],
                                                    createdTime:
                                                        document['createdTime'],
                                                  )));
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 114, 206, 248),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    color: Color.fromARGB(255, 134, 241, 209),
                                  ),
                                  RaisedButton(
                                    elevation: 3.0,
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('usersId')
                                          .doc(loggedInUser.uid)
                                          .collection('tasks')
                                          .doc(document.id)
                                          .delete();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    color: Color.fromARGB(255, 240, 127, 119),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => SigninScreen()),
      (route) => false);
}
