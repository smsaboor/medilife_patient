import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/family_members/add_new_member.dart';
import 'package:medilife_patient/dashboard_patient/lab_test/add_lab_test.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/dashboard_patient/lab_test/custom_test_display.dart';
import 'member_card.dart';

class DisplayFamilyMembers extends StatefulWidget {
  const DisplayFamilyMembers({Key? key, required this.patientId}) : super(key: key);
  final patientId;
  @override
  State<DisplayFamilyMembers> createState() => _DisplayFamilyMembersState();
}

class _DisplayFamilyMembersState extends State<DisplayFamilyMembers> {
  var allTest;
  bool allTestF = true;
  bool deleteTestFlag = false;

  Future<void> getAllTest() async {
    var API = 'member_list_api.php';
    Map<String, dynamic> body = {'patient_id': widget.patientId};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      allTest = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          allTestF = false;
        });
      }
    } else {}
  }

  Future<String> deleteLabTest(String id) async {
    deleteTestFlag = true;
    var data;
    String API = 'delete_lab_test_api.php';
    Map<String, dynamic> body = {'lab_id': id};
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
      return data[0]['status'];
    } else {
      return 'fail';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Members'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                child: Column(children: [
                  allTestF ? Center(child: Text(''),) : allTest == null
                      ? Center(child: Text('No Members Found.'),)
                      : Container(),
                  allTestF
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child:
                      FutureBuilder(
                          future: getAllTest(),
                          builder: (context, snapshot) {
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: allTest[0]['members'].length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: MemberCard(
                                        test: allTest[0]['members'][index],
                                        status: 2,
                                        patientId: widget.patientId
                                    ),
                                    onTap: () async {},
                                  );
                                });
                          })

                  ),
                ]))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (_) => AddMemberPD(patientID: widget.patientId)));
        },
      ),
    );
  }
}
