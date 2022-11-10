import 'package:badges/badges.dart';
import 'package:medilife_patient/dashboard_patient/data/json.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/theme/colors.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/widgets/popular_doctor.dart';
import 'package:medilife_patient/dashboard_patient/widgets/textbox.dart';
import 'package:flutter/material.dart';

class DoctorCardList extends StatefulWidget {
  const DoctorCardList({Key? key}) : super(key: key);
  @override
  _DoctorCardListState createState() => _DoctorCardListState();
}

class _DoctorCardListState extends State<DoctorCardList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Doctors",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.info,
              color: Colors.grey,
            ),
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: const [
                  Expanded(child: CustomTextBoxPD()),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.filter_list_rounded,
                    color: primary,
                    size: 35,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List.generate(
                        chatsData.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Badge(
                                  badgeColor: Colors.green,
                                  borderSide: const BorderSide(color: Colors.white),
                                  position:
                                      BadgePosition.topEnd(top: -3, end: 0),
                                  badgeContent: const Text(''),
                                  child: AvatarImagePD(
                                      chatsData[index]["image"].toString())),
                            ))),
              ),
              const SizedBox(
                height: 20,
              ),
              getDoctorList()
            ])));
  }

  getDoctorList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PopularDoctorPD(
              doctor: doctors[index],
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => DoctorProfilePagePD(doctor: doctors[index],patient: '1')));
        },
      ),
    );
  }
}
