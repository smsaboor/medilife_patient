import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/core/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:http/http.dart' as http;


class MemberCard extends StatefulWidget {
  MemberCard({Key? key,
    required this.test,
    required this.status,
    required this.patientId})
      : super(key: key);
  var test;
  final status;
  final patientId;

  @override
  State<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool allTestF = true;
  bool deleteTestFlag = false;
  bool bookTestFlag = false;

  Future<void> deleteLabTest(String id) async {
    if (mounted) {
      setState(() {
        deleteTestFlag = true;
      });
    }
    var data;
    String API = 'delete_lab_test_api.php';
    Map<String, dynamic> body = {'id': id};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to delete: $error"));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          deleteTestFlag = false;
        });
      }
      if (data[0]['status'] == 'ok') {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Lab Test is Canceled !',
            color: Colors.green);
      } else {
        CustomSnackBar.snackBar(
            context: context, data: 'oops somthing wrong !', color: Colors.red);
      }
    } else {}
  }

  Future<void> bookLabTest(String id) async {
    if (mounted) {
      setState(() {
        bookTestFlag = true;
      });
    }
    var data;
    String API = 'add_lab_test_api.php';
    Map<String, dynamic> body = {
      'lab_test_id': id,
      'patient_id': widget.patientId,
      'fees': widget.test["fees"]
    };
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to delete: $error"));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          bookTestFlag = false;
        });
      }
      if (data[0]['status'] == '1') {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Lab Test Booked Successfully !',
            color: Colors.green);
      } else {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Lab Test Booking Fail !',
            color: Colors.red);
      }
      Navigator.pop(context);
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Container(
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.only(left: 5, top: 15),
          width: MediaQuery
              .of(context)
              .size
              .width * .7,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 10,),
             Text('Name: ${widget.test['name']}'),
              Text('Relation: ${widget.test['relation']}'),
              Text('Age: ${widget.test['age']}'),
              Text('Gender: ${widget.test['gender']}'),


            ],
          )),
    );
  }
}
