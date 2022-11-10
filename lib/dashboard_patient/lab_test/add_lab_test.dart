import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:medilife_patient/core/constants.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/dashboard_patient/lab_test/custom_test_display.dart';
import 'package:flutter_package1/loading/loading_card_list.dart';

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
        .get(Uri.parse(API_BASE_URL + API));
    if (response.statusCode == 200) {
      allTest = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          allTestF=false;
        });
      }
    } else {
      throw Exception('Failed to lab test');
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
        title: const Text('Select Lab Test'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                child: Column(children: [
                  allTestF
                      ? LoadingCardList()
                      : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
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
