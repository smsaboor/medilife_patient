import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/core/custom_snackbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class UpComingAppointments2 extends StatefulWidget {
  UpComingAppointments2({Key? key, required this.doctor}) : super(key: key);
  var doctor;

  @override
  State<UpComingAppointments2> createState() => _UpComingAppointments2State();
}

class _UpComingAppointments2State extends State<UpComingAppointments2> {
  bool noAppointment = false;
  bool deleteTestFlag = false;

  Future<void> deleteLabTest(String id) async {
    setState(() {
      deleteTestFlag = true;
    });
    var data;
    String API = 'delete_patient_appointment_api.php';
    Map<String, dynamic> body = {'id': id};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to delete: $error"));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body.toString());
      setState(() {
        deleteTestFlag = false;
      });
      if (data[0]['status'] == 'ok') {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Appointment Cancelled !',
            color: Colors.green);
      } else {
        CustomSnackBar.snackBar(
            context: context, data: 'oops somthing wrong !', color: Colors.red);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return noAppointment
        ? Container(
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.only(left: 5, top: 15),
            width: MediaQuery.of(context).size.width * .8,
            height: 220,
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
                SizedBox(
                  height: 150,
                  width: 170,
                  child: Image.asset('assets/appointments.png'),
                )
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.only(left: 5, top: 15),
            width: MediaQuery.of(context).size.width * .8,
            height: 230,
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
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 5),
                              child: Icon(
                                Icons.local_hospital,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            Text(
                              'Dr. ${widget.doctor['doctor_name'] ?? 'fail'}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Divider(height: 2),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, bottom: 4, top: 5),
                          child: Row(
                            children: [
                              Text(
                                'Patient Name: ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${widget.doctor['member_name'] == null ? widget.doctor['patient_name'] : widget.doctor['member_name']}',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'Symtoms: ',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                '${widget.doctor['symptoms']}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Apmnt No.",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue),
                                  ),
                                  Text(
                                    widget.doctor['appointment_no'] ?? 'fail',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 150),
                              child: Column(
                                children: [
                                  Text(
                                    "Date & Time",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue),
                                  ),
                                  Text(
                                    widget.doctor['date'] ?? 'fail',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.doctor['booking_slot'] ?? 'fail',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width * .3,
                        height: 25,
                        color: Colors.orange,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Status: ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      widget.doctor['status'] ?? 'fail',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(height: 8,),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  height: 45,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        _showDialog(
                            widget.doctor["id"].toString());
                        // showDialog(
                        //     context: context,
                        //     builder: (_) {
                        //       // return AlertDialog(
                        //       //   title: Center(child: Text('Delete Confirmation ?')),
                        //       //   content: Container(
                        //       //     height: 60,
                        //       //     width: MediaQuery.of(context).size.width*.7,
                        //       //     child: Text('Are you confirm to delete.'),
                        //       //   ),
                        //       //   actions: <Widget>[
                        //       //     ElevatedButton(
                        //       //       child: Text('Ok'),
                        //       //       onPressed: (){
                        //       //         deleteLabTest(widget.doctor["id"].toString());
                        //       //       },
                        //       //     ),
                        //       //     ElevatedButton(
                        //       //         child: Text('cancel'),
                        //       //         onPressed: () => Navigator.pop(context))
                        //       //   ],
                        //       // );
                        //     });
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      child: deleteTestFlag
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Cancel',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                    ),
                  ),
                )
              ],
            ));
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
      btnCancelOnPress: () {
      },
    ).show();
  }

}
