// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_brace_in_string_interps, avoid_print, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class Updatetasks extends StatefulWidget {
  String? userId;
  String? noteId;
  String? title;
  String? description;
  String? createdDate;
  String? createdTime;
  Updatetasks({
    Key? key,
    required this.userId,
    required this.noteId,
    required this.title,
    required this.description,
    required this.createdDate,
    required this.createdTime,
  }) : super(key: key);

  @override
  State<Updatetasks> createState() => _UpdatetasksState();
}

class _UpdatetasksState extends State<Updatetasks> {
  String? _setTime, _setDate;

  String? _hour, _minute, _time;

  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      // ignore: curly_braces_in_flow_control_structures
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '${_hour!} : ${_minute!}';
        _timeController.text = _time!;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 174, 227, 243),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 170, 202, 238),
        elevation: 0.0,
        title: Text(
          'Update Task',
          style: TextStyle(
              color: Color.fromARGB(255, 129, 189, 238), fontSize: 30.0),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.blue)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              TextField(
                textInputAction: TextInputAction.next,
                controller: _titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Title',
                    hintText: 'Enter title of your Task........'),
              ),
              SizedBox(height: 20.0),
              TextField(
                textInputAction: TextInputAction.next,
                controller: _descriptionController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Enter Task Description',
                    hintText: 'Enter description a Task........'),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Enter Modify Date',
                    hintText: 'Enter modify date of your task........'),
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _timeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Enter Modify Time',
                    hintText: 'Enter modify time of your task........'),
                onTap: () {
                  _selectTime(context);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () {
                  print(widget.noteId);
                  updateUser(
                    _titleController.text,
                    _descriptionController.text,
                    _dateController.text,
                    _timeController.text,
                  );
                },
                child: Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUser(title, description, date, time) {
    return FirebaseFirestore.instance
        .doc('usersId/${widget.userId}/tasks/${widget.noteId}')
        .update({
          'title': title,
          'description': description,
          'updatedDate': date,
          'updatedTime': time,
        })
        .then((value) => Navigator.pop(context))
        .catchError((error) => print("Failed to update user: $error"));
  }

  getDocumentID() {
    FirebaseFirestore.instance
        .collection('usersId')
        .doc(widget.userId)
        .collection('tasks')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print("Note ID: ${element.id}");
      });
    });
  }
}
