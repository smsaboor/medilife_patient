import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpComingAppointments extends StatelessWidget {
  UpComingAppointments({Key? key, required this.doctor}) : super(key: key);
  var doctor;
  bool noAppointment = false;

  @override
  Widget build(BuildContext context) {
    return noAppointment
        ? Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.only(left: 5, top: 15),
            width: MediaQuery.of(context).size.width * .8,
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
                SizedBox(
                  height: 150,
                  width: 170,
                  child: Image.asset('assets/appointments.png'),
                )
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.only(left: 5, top: 15),
            width: MediaQuery.of(context).size.width * .8,
            height: 190,
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
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_hospital,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Expanded(
                        child: Text(
                          '  Dr. ${doctor['doctor_name'].length > 15
                              ? doctor['doctor_name']
                              .substring(0, 15) +
                              '...'.toString().toUpperCase()
                              : doctor['doctor_name'].toString().toUpperCase() ?? ''}',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.visible, //
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 2),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 4, top: 5),
                  child: Row(
                    children: [
                      const Text(
                        'Patient Name: ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Expanded(
                        child: Text(
                          '${doctor['member_name'] == null ? (doctor['patient_name'].length > 20
                              ? doctor['patient_name']
                              .substring(0, 20) +
                              '...'
                              : doctor['patient_name'] ?? '') : ((doctor['member_name'].length > 20
                              ? doctor['member_name']
                              .substring(0, 20) +
                              '...'
                              : doctor['member_name'] ?? ''))}'.toString().toUpperCase(),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis, //
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      const Text(
                        'Symptoms: ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                      Expanded(
                        child: Text(
                          doctor['symptoms'].length > 25
                              ? doctor['symptoms']
                              .substring(0, 25) +
                              '...'
                              : doctor['symptoms'] ?? '',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.visible, //
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
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
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 150),
                        child: Column(
                          children: [
                            const Text(
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
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              doctor['booking_slot'] ?? 'fail',
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                                    const Text(
                                      'Status: ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      doctor['status'] ?? 'fail',
                                      style: const TextStyle(
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
                )
              ],
            ));
  }
}
