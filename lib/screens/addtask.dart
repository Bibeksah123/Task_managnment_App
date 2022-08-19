// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_brace_in_string_interps, avoid_print, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  String? userId;

  AddTask({key: Key, required this.userId});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
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
      backgroundColor: Color.fromARGB(255, 183, 220, 245),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 170, 191, 248),
        elevation: 0.0,
        title: Text('Add Task',
            style: TextStyle(color: Colors.black, fontSize: 25.0)),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
        ),
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
                    labelText: 'Enter Title',
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
                    labelText: 'Enter Description',
                    hintText: 'Enter description of your Task........'),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Enter Date',
                    hintText: 'Enter date of your Task........'),
                onTap: () {
                  _selectDate(context);
                },
              ),
              // SizedBox(height: 20.0),
              // TextField(
              //   controller: _timeController,
              //   decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       labelText: 'Enter Time',
              //       hintText: 'Enter time of your Task........'),
              //   onTap: () {
              //     _selectTime(context);
              //   },
              // ),
              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: () {
                  posttasks(
                      widget.userId,
                      _titleController.text,
                      _descriptionController.text,
                      _dateController.text,
                      _timeController.text);
                  Navigator.pop(context, {
                    'title': _titleController.text,
                    'description': _descriptionController.text,
                    'date': _dateController.text,
                  });
                  print(
                      "${_titleController.text}\n${_descriptionController.text}\n${_dateController.text}\n${_timeController.text}\n${widget.userId}");
                  getDocumentID();
                  print("================");
                },
                child: Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  posttasks(userId, title, description, date, time) {
    FirebaseFirestore.instance
        .collection('usersId')
        .doc(userId)
        .collection('tasks')
        .add({
      'title': title,
      'description': description,
      'createdDate': date,
      'createdTime': time,
      'updatedDate': date,
      'updatedTime': time,
    });
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
