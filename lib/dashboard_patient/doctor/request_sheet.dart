import 'dart:convert';

import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/core/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/data/json.dart';
import 'package:medilife_patient/dashboard_patient/data/members.dart';
import 'package:medilife_patient/dashboard_patient/family_members/add_new_member.dart';
import 'package:medilife_patient/dashboard_patient/doctor/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

class ModelSymptoms {
  ModelSymptoms({
    this.symptoms_name,
  });

  String? symptoms_name;

  factory ModelSymptoms.fromJson(Map<String, dynamic> json) => ModelSymptoms(
        symptoms_name: json["symptoms_name"],
      );

  Map<String, dynamic> toJson() => {
        "symptoms_name": symptoms_name,
      };
}

class RequestSheet extends StatefulWidget {
  const RequestSheet(
      {Key? key,
      required this.patient,
      required this.doctor,
      required this.totalConsult})
      : super(key: key);
  final patient;
  final doctor;
  final totalConsult;

  @override
  State<RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends State<RequestSheet> {
  var members;
  bool membersF = true;
  bool familyMembers=true;
  List<dynamic>? modelSymptoms1 = [];
  List<dynamic>? modelSymptoms2 = [];
  String? textLanguages = '';
  var fetchUserData;
  bool flagAccess = true;

  // Future<void> getSelectedSymtoms() async {
  //   var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/symptoms_api.php';
  //   http.Response response = await http
  //       .post(Uri.parse(API))
  //       .then((value) => value)
  //       .catchError((error) => print(" Failed to getAllPills $error"));
  //   modelSymptoms2!.clear();
  //   if (response.statusCode == 200) {
  //     fetchUserData = jsonDecode(response.body.toString());
  //     if (textLanguages!.length == 0) {
  //       print(
  //           '5.2.......................${fetchUserData[0]['symptoms_name']}.......}');
  //       textLanguages = fetchUserData[0]['symptoms_name'].toString();
  //       String firstTextL = textLanguages!;
  //       String finalStringL = firstTextL
  //           .replaceAll("[", "")
  //           .replaceAll("]", "")
  //           .replaceAll(" ", "");
  //       final splitedTextL = finalStringL.split(',');
  //       if (textLanguages!.length == 0) {
  //         print(
  //             '5........................${modelSymptoms1![0]['symptoms_name']}.......}');
  //         modelSymptoms1 = [];
  //       } else {
  //         for (int i = 0; i < splitedTextL.length; i++) {
  //           print('77777getUserData777777755$i--${splitedTextL[i].toString()}');
  //           modelSymptoms1!.add(splitedTextL[i].toString());
  //         }
  //       }
  //     } else {}
  //   }
  // }

  Future<void> getMembers() async {
    var API = 'member_list_api.php';
    Map<String, dynamic> body = {'patient_id': widget.patient['user_id']};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      members = jsonDecode(response.body.toString());
      setState(() {
        membersF = false;
      });
    } else {}
  }

  Future<String> deleteMember(String id) async {
    String API2 = 'delete_member_api.php';
    var data;
    var API = API_BASE_URL + API2;
    Map<String, dynamic> body = {'member_id': id};
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to delete: $error"));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      setState(() {});
      return data[0]['status'];
    } else {
      return 'fail';
    }
  }

  _showDialog(String id) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
      width: MediaQuery.of(context).size.width,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      animType: AnimType.LEFTSLIDE,
      headerAnimationLoop: false,
      showCloseIcon: true,
      title: 'Delete',
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      desc: 'Are You Confirm to delete.',
      btnOkOnPress: () async {
        String status = await deleteMember(id);
        if (status == 'ok') {
          CustomSnackBar.snackBar(
              context: context,
              data: 'Deleted Successfully !',
              color: Colors.green);
        } else {
          CustomSnackBar.snackBar(
              context: context, data: 'Deleted Fail !', color: Colors.red);
        }
      },
    ).show();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getSelectedSymtoms();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 5),
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .65,
                    child: Text('Select Member',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.red)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .25,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              textStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AddMemberPD(
                                    patientID: widget.patient['user_id'])));
                          },
                          child: Text('+ Add')),
                    ),
                  )
                ],
              ),
            ),
            Row(children: [
              membersF
                  ? CircularProgressIndicator()
                  : Container(
                      height: 130,
                      child: FutureBuilder(
                          future: getMembers(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: members.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .15,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff125ace),
                                              child: Text(
                                                members[index]
                                                        ['Patient_name']![0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 34,
                                                    color: Colors.white),
                                              ), //Text
                                            ), //circleAvatar,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            members[index]['Patient_name']!
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context, true);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (_) => BookingScreenPD(
                                                patientId:widget.patient['user_id'],
                                                    familyMember:
                                                        members[index],
                                                    doctor: widget.doctor,
                                                    totalConsult:
                                                        widget.totalConsult,
                                                    memberType: 1,
                                                  )));
                                    },
                                  );
                                });
                          }),
                    ),
              SizedBox(
                width: 5,
              ),
              membersF?
                  Container():Container(
                      height: 150,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: members[0]['members'].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context, true);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => BookingScreenPD(
                                      patientId:widget.patient['user_id'],
                                      familyMember: members[0]['members']
                                      [index],
                                      doctor: widget.doctor,
                                      symptoms: modelSymptoms1,
                                      totalConsult: widget.totalConsult,
                                      memberType: 2,
                                    )));
                              },

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .15,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .15,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xff125ace),
                                        child: Text(
                                          members[0]['members'][index]
                                                  ['name']![0]
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 34,
                                              color: Colors.white),
                                        ), //Text
                                      ), //circleAvatar,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      members[0]['members'][index]['name']!
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                                    // SizedBox(
                                    //   height: 5,
                                    // ),
                                    // SizedBox(
                                    //   width: 50,
                                    //   height: 25,
                                    //   child: ElevatedButton(
                                    //       style: ElevatedButton.styleFrom(
                                    //           primary: Colors.red,
                                    //          ),
                                    //       onPressed: () {
                                    //         _showDialog(
                                    //             members[0]['members'][index]['member_id']);
                                    //       },
                                    //       child: Text('Delete',style: TextStyle(fontSize: 8),)),
                                    // ),
                                  ],
                                ),
                              ),
                              onLongPress: () {
                                _showDialog(
                                    members[0]['members'][index]['member_id']);
                              },

                            );
                          }),
                    ),
            ]),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
