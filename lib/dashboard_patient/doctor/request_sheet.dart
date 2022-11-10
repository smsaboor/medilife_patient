import 'dart:convert';

import 'package:medilife_patient/core/constants.dart';
import 'package:flutter_package1/custom_snackbar.dart';
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
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 5),
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 240,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .65,
                    child: const Text('Select Member',
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
                              textStyle: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AddMemberPD(
                                    patientID: widget.patient['user_id'])));
                          },
                          child: const Text('+ Add')),
                    ),
                  )
                ],
              ),
            ),
            Row(children: [
              membersF
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 130,
                      child: FutureBuilder(
                          future: getMembers(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
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
                                                  const Color(0xff125ace),
                                              child: Text(
                                                members[index]['Patient_name']![0]
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 34,
                                                    color: Colors.white),
                                              ), //Text
                                            ), //circleAvatar,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            members[index]['Patient_name'].length > 10 ?
                                            members[index]['Patient_name'].substring(0, 10)+'...' :
                                            members[index]['Patient_name'] ?? '',
                                            // members[index]['Patient_name']!
                                            //     .toUpperCase(),
                                            style: const TextStyle(
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
              const SizedBox(
                width: 5,
              ),
              membersF?
                  Container():SizedBox(
                      height: 150,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
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
                                        backgroundColor: const Color(0xff125ace),
                                        child: Text(
                                          members[0]['members'][index]
                                                  ['name']![0]
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 34,
                                              color: Colors.white),
                                        ), //Text
                                      ), //circleAvatar,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      members[0]['members'][index]['name'].length > 14 ?
                                      members[0]['members'][index]['name'].substring(0, 15)+'...' :
                                      members[0]['members'][index]['name'] ?? '',
                                      // members[0]['members'][index]['name']!
                                      //     .toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
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
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
