import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:flutter_package1/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:http/http.dart' as http;
import 'sheet_lab_test.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TestCard extends StatefulWidget {
  TestCard(
      {Key? key,
      required this.test,
      required this.status,
      required this.patientId})
      : super(key: key);
  var test;
  final status;
  final patientId;

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
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
            context: context, data: 'oops something wrong !', color: Colors.red);
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
      if (!mounted) return;
      Navigator.of(context).pop();
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
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.only(left: 5, top: 15),
          width: MediaQuery.of(context).size.width * .8,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(1, 1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: AvatarImagePD(widget.test["image"] ??
                        'https://images.unsplash.com/photo-1625498542602-6bfb30f39b3f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.local_hospital,
                            color: Colors.blue,
                            size: 26,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.test["test_name"].length > 15
                                ? widget.test["test_name"].substring(0, 15) +
                                    '...'
                                : widget.test["test_name"] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.status == 2
                              ? Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        'Patient Name: ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.test["member_name"] == ''
                                          ? (widget.test["patient_name"]
                                                      .toString()
                                                      .length >
                                                  20
                                              ? '${widget.test["patient_name"]
                                                      .toString()
                                                      .substring(0, 20)}...'
                                              : widget.test["patient_name"]
                                                      .toString() ??
                                                  '')
                                          : (widget.test["member_name"]
                                          .toString()
                                          .length >
                                          20
                                          ? '${widget.test["member_name"]
                                          .toString()
                                          .substring(0, 20)}...'
                                          : widget.test["member_name"]
                                          .toString() ??
                                          ''),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.info,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'No special preparation required',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.watch_later_outlined,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Report in 24 Hours',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Container(
                                  width: 120,
                                  height: 30,
                                  color: Colors.orange,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Fees: ${'₹'} ${widget.test["fees"].toString().length>5 ? '${widget.test["fees"]
                                                .toString()
                                                .substring(0, 5)}...'
                                                : widget.test["fees"]
                                                .toString() ??
                                                ''}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              widget.status == 2
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          _showDialog(widget.test["id"].toString());
                          // deleteLabTest(widget.test["id"].toString());
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        child: deleteTestFlag
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .7,
                      height: 45,
                      child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            // bookLabTest(widget.test["id"].toString());
                            _modalMenu(widget.test["test_name"] ?? '');
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              textStyle: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          child: bookTestFlag
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  bookTestFlag ? 'loading..' : 'Book',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                        ),
                      ),
                    )
            ],
          )),
    );
  }

  void _modalMenu(String testName) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SheetLabTest(
            patientId: widget.patientId,
            testName: testName,
            fees: widget.test["fees"].toString(),
            testId: widget.test["id"].toString());
      },
    );
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
        deleteLabTest(id);
      },
      btnOkText: 'Yes',
      btnCancelOnPress: () {},
    ).show();
  }
}
