import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpComingAppointments extends StatelessWidget {
  UpComingAppointments({Key? key, required this.doctor}) : super(key: key);
  var doctor;
  bool noAppointment = false;

  @override
  Widget build(BuildContext context) {
    return noAppointment ? Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.only(left: 5, top: 15),
        width: MediaQuery
            .of(context)
            .size
            .width * .8,
        height: 170,
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
        child:Column(children: [
          SizedBox(height: 150,width: 170,child: Image.asset('assets/appointments.png'),)
        ],),) : Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.only(left: 5, top: 15),
        width: MediaQuery
            .of(context)
            .size
            .width * .8,
        height: 170,
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
                          padding: const EdgeInsets.only(left: 8.0, right: 5),
                          child: Icon(
                            Icons.local_hospital,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        Text(
                          'Dr. ${doctor['doctor_name'] ?? 'fail'}',
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Divider(height: 2),
                    Padding(
                      padding: const EdgeInsets.only(left:10.0,bottom: 4,top: 5),
                      child: Row(
                        children: [
                          Text(
                            'Patient Name: ',
                            style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${doctor['member_name']==null? doctor['patient_name']:doctor['member_name']}',
                            style:
                            TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Row(
                        children: [
                          Text(
                            'Symtoms: ',
                            style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '${doctor['symptoms']}',
                            style:
                            TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 2,),
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
                                doctor['appointment_no'] ?? 'fail',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,),
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
                                doctor['date'] ?? 'fail',
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                doctor['booking_slot'] ?? 'fail',
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
            SizedBox(height: 5,),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .3,
                    height: 25,
                    color: Colors.orange,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
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
                                doctor['status'] ?? 'fail',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],)

                          ],
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ));
  }
}
