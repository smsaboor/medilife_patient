import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/lab_test/add_lab_test.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/dashboard_patient/lab_test/custom_test_display.dart';
import 'package:flutter_package1/loading/loading_card_list.dart';
class DisplayLabTest extends StatefulWidget {
  const DisplayLabTest({Key? key, required this.patientId}) : super(key: key);
  final patientId;
  @override
  State<DisplayLabTest> createState() => _DisplayLabTestState();
}

class _DisplayLabTestState extends State<DisplayLabTest> {
  var allTest;
  bool allTestF = true;
  bool deleteTestFlag = false;

  Future<void> getAllTest() async {
    var API = 'all_booked_lab_test_api.php';
    Map<String, dynamic> body = {'patient_id': widget.patientId};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API),body: body);
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

  Future<String> deleteLabTest(String id) async {
    deleteTestFlag = true;
    var data;
    String API = 'delete_lab_test_api.php';
    Map<String, dynamic> body = {'lab_id': id};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API),body: body);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          deleteTestFlag = false;
        });
      }
      return data[0]['status'];
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
        title: const Text('My Lab Test'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                child: Column(children: [
                  allTestF ? const Center(child: Text(''),) : allTest == null || allTest.length==0
                      ? const Center(child: Text('No Lab Test Booked.'),)
                      : Container(),
                  allTestF
                      ? LoadingCardList()
                      : SizedBox(
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
                                physics: const ScrollPhysics(),
                                itemCount: allTest.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: TestCard(
                                        test: allTest[index],
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
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (_) => AddLabTest(patientId: widget.patientId)));
        },
        // isExtended: true,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
