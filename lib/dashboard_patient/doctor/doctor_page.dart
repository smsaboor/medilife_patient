import 'package:badges/badges.dart';
import 'package:medilife_patient/dashboard_patient/data/json.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/theme/colors.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/widgets/doctor_box.dart';
import 'package:medilife_patient/dashboard_patient/widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DoctorPagePD extends StatefulWidget {
  const DoctorPagePD({Key? key}) : super(key: key);

  @override
  _DoctorPagePDState createState() => _DoctorPagePDState();
}

class _DoctorPagePDState extends State<DoctorPagePD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Doctors",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
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
                children: [
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
              SizedBox(
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
                                  borderSide: BorderSide(color: Colors.white),
                                  position:
                                      BadgePosition.topEnd(top: -3, end: 0),
                                  badgeContent: Text(''),
                                  child: AvatarImagePD(
                                      chatsData[index]["image"].toString())),
                            ))),
              ),
              SizedBox(
                height: 20,
              ),
              getDoctorList()
            ])));
  }

  getDoctorList() {
    return new StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      itemCount: doctors.length,
      itemBuilder: (BuildContext context, int index) => DoctorBoxPD(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DoctorProfilePagePD(doctor: doctors[index],
                        patient: '1',
                        )));
          },
          index: index,
          doctor: doctors[index]),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 3 : 2),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    );
  }
}
