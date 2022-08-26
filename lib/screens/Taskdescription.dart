import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteDescription extends StatefulWidget {
  String userId;
  String title;
  String description;
  String createdDate;
  String createdTime;
  NoteDescription({
    Key? key,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.createdTime,
  }) : super(key: key);

  @override
  State<NoteDescription> createState() => _NoteDescriptionState();
}

class _NoteDescriptionState extends State<NoteDescription> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 133, 175, 253),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(widget.title,
            style: TextStyle(color: Colors.black, fontSize: 25.0)),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 162, 206, 241),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            Divider(color: Colors.black, height: 3.0),
            SizedBox(height: 10.0),
            Text("${widget.createdTime} | ${widget.createdTime}"),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
