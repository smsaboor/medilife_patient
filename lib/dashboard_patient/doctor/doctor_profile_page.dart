import 'dart:convert';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/doctor/request_sheet.dart';
import 'package:medilife_patient/dashboard_patient/theme/colors.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/widgets/doctor_info_box.dart';
import 'package:medilife_patient/dashboard_patient/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorProfilePagePD extends StatefulWidget {
  const DoctorProfilePagePD(
      {Key? key, required this.doctor, required this.patient})
      : super(key: key);
  final doctor;
  final patient;

  @override
  _DoctorProfilePagePDState createState() => _DoctorProfilePagePDState();
}

class _DoctorProfilePagePDState extends State<DoctorProfilePagePD> {
  var liveConsult;
  var lastBooking;
  var succesfulPatient;
  var experience;
  var successfullOT;
  var certificate;

  bool liveConsultF = true;
  bool lastBookingF = true;
  bool succesfulPatientF = true;
  bool experienceF = true;
  bool successfullOTF = true;
  bool certificateF = true;
  int bodyIndex=1;
  bool allLodingF=true;

  Future<void> getLiveConsult() async {
    var API = 'doctor_dashboard_api.php';
    Map<String, dynamic> body = {'doctor_id': widget.doctor['id']};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      liveConsult = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          liveConsultF = false;
          bodyIndex=2;
          allLodingF=false;
        });
      }
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLiveConsult();
  }

  void _modalMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return RequestSheet(
            patient: widget.patient,
            doctor: widget.doctor,
            totalConsult: '2');
      },
    );
  }
getScafold()async{
  await Future.delayed(Duration(seconds: 2));

}
  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  switchBody(){
    switch(bodyIndex){
      case 1: return getBody2();
      case 2: return getBody();
    }
  }

  getBody2(){
    return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
  }
  getBody() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Doctor's Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AvatarImagePD(
                  widget.doctor['image'].toString(),
                  radius: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 0),
                  child: Column(
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
                          Text(widget.doctor["clinic_name"].length > 20 ?
                          widget.doctor["clinic_name"].substring(0, 20)+'...' :
                          widget.doctor["clinic_name"] ?? '',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Dr. ${widget.doctor["doctor_name"].length > 20 ?
                      widget.doctor["doctor_name"].substring(0, 20)+'...' :
                      widget.doctor["doctor_name"] ?? ''}',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                          widget.doctor["degree"].toString().replaceAll('[', '').replaceAll(']', '').length > 25 ?
                          '${widget.doctor["degree"].toString().replaceAll('[', '').replaceAll(']', '').substring(0, 25)}...' :
                          widget.doctor["degree"].toString().replaceAll('[', '').replaceAll(']', '') ??'',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.pink)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '').length > 30 ?
                        '${widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '').substring(0, 30)}...' :
                        widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '') ??'',
                        // widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '')  ?? '',
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Speak: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '').length > 25 ?
                            '${widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '').substring(0, 25)}...' :
                            widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '') ??'',
                            // widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '')  ?? '',
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0, top: 5),
                        child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: 120,
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
                                      Text(
                                        'Fees: ${widget.doctor['doctor_fee']}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.orangeAccent,
                ),
                const Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.orangeAccent,
                ),
                const Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.orangeAccent,
                ),
                const Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.orangeAccent,
                ),
                Icon(
                  Icons.star,
                  size: 18,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text("4.0 Out of 5.0",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(
              height: 3,
            ),
            const Text(
              "340 Patients review",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white70, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ContactBox(icon: Icons.videocam_rounded, color: Colors.blue,),
                  Column(
                    children: [
                      const Text("Live Consultant",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                          "${allLodingF ? '' : liveConsult[0]['current_appointment'].toString()} / ${liveConsultF ? '' : liveConsult[0]['today_booking'].toString()}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.pink)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Last Booking Number",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                          allLodingF
                              ? ''
                              : liveConsult[0]['last_booking_nummber'].toString()!=null?
                          liveConsult[0]['last_booking_nummber'].toString():
                          'No Last Booking',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.pink)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DoctorInfoBoxPD(
                  value: allLodingF
                      ? ''
                      : "${liveConsult[0]['total_successfully_patient']}+",
                  info: "Successful Patients",
                  icon: Icons.groups_rounded,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 20,
                ),
                DoctorInfoBoxPD(
                  value:
                  "${allLodingF ? '' : liveConsult[0]['total_experience']} Years",
                  info: "Experience",
                  icon: Icons.medical_services_rounded,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DoctorInfoBoxPD(
                  value: allLodingF
                      ? ''
                      : "${liveConsult[0]['total_operations']}+",
                  info: "Successful OT",
                  icon: Icons.bloodtype_rounded,
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 20,
                ),
                DoctorInfoBoxPD(
                  value:
                  "${allLodingF ? '' : liveConsult[0]['total_certificate_achieved']}+",
                  info: "Certificates Achieved",
                  icon: Icons.card_membership_rounded,
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: MyButtonPD(
            disableButton: false,
            bgColor: primary,
            title: allLodingF?"Loading...":"Book Appointment",
            onTap: () async {
              allLodingF?null:_modalMenu();
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
