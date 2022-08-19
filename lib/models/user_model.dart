import 'dart:ffi';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  Array? subjects;

  UserModel(
      {this.uid, this.email, this.firstName, this.secondName, this.subjects});

  // receving data from server

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      // subjects: map['subjects'],
    );
  }
// sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      // 'subjects': subjects,
    };
  }
}
