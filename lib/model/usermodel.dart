import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? number;
  String? academicYear;
  String? admissionClass;
  String? dob;
  String? fatherName;
  String? motherName;
  String? displayName;
  UserModel(
      {  this.uid,
        this.email,
        this.firstName,
        this.secondName,
        this.number,
        this.academicYear,
        this.admissionClass,
        this.dob,
        this.fatherName,
        this.motherName,
        this.displayName,
      });


  // Receiving data from Server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['firstName'],
        secondName: map['secondName'],
        number:  map['number'],
        academicYear:  map['academicYear'],
        admissionClass: map['admissionClass'],
        dob:  map['dob'],
        fatherName: map['fatherName'],
        motherName: map['motherName'],
        displayName: map(['firstName']+['secondName'])
    );
  }

  toJson(){
    return {"firstName":  firstName, "email": email, "secondName": secondName, "number": number, "academicYear": academicYear, "admissionClass": admissionClass,
    "dob": dob, "fatherName": fatherName, "motherName": motherName, "displayName": displayName,
    };
  }


  //Step-1 Map user fetched from firebase to userModel
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>>document){
    final data = document.data()!;
    return UserModel(
        uid: document.id,email: data['email'], firstName: data['firstName'], secondName: data['secondName'], number: data['number'],

    motherName: data['motherName'] , displayName: data['firstName'+'secondName']
    );
  }

  //Sending Data to Our Server
  Map<String, dynamic>toMap(){
    return{
      'uid' : uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'academicYear': academicYear,
      'admissionClass' : admissionClass,
      'dob': dob,
      'fatherName': fatherName,
      'motherName': motherName,
      'displayName': displayName,
    };
}

}
