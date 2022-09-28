import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/lab_test/add_lab_test.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/dashboard_patient/lab_test/custom_test_display.dart';


class AddLabTest extends StatefulWidget {
  const AddLabTest({Key? key,required this.patientId}) : super(key: key);
  final patientId;
  @override
  State<AddLabTest> createState() => _AddLabTestState();
}

class _AddLabTestState extends State<AddLabTest> {
  var allTest;
  bool allTestF=true;

  Future<void> getAllTest() async {
    var API = 'all_lab_tests_api.php';
    http.Response response = await http
        .get(Uri.parse(API_BASE_URL + API))
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      allTest = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          allTestF=false;
        });
      }
    } else {}
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
        title: Text('Select Lab Test'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                child: Column(children: [
                  allTestF
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: allTest.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: TestCard(
                                test: allTest[index],
                                  status:1,
                                patientId: widget.patientId,
                              ),
                              onTap: () async {

                              },
                            );
                          })),
                ]))
          ],
        ),
      ),
    );
  }
}
