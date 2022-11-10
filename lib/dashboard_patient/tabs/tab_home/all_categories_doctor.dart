import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/widgets/popular_doctor.dart';
import 'package:flutter_package1/loading/loading_card_list.dart';
class AllCategoriesDoctor extends StatefulWidget {
  const AllCategoriesDoctor(
      {Key? key,
      required this.title,
      required this.searchKey,
      required this.userData})
      : super(key: key);
  final title;
  final searchKey;
  final userData;

  @override
  State<AllCategoriesDoctor> createState() => _AllCategoriesDoctorState();
}

class _AllCategoriesDoctorState extends State<AllCategoriesDoctor> {
  var allDoctors;
  bool allDoctorsF = true;

  Future<void> getAllDoctors() async {
    var API = 'specialist_filter_api.php';
    Map<String, dynamic> body = {'speciality': widget.searchKey};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(error));
    if (response.statusCode == 200) {
      allDoctors = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          allDoctorsF = false;
        });
      }
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.blue,
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              title: Text('${widget.title} Specialist'),
              centerTitle: true,
            ),
            const SizedBox(
              height: 20,
            ),
            allDoctorsF
                ? LoadingCardList()
                : allDoctors[0]['status']==0?Center(child: Text('No ${widget.title} Specialist Found'),):ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: allDoctors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 8, bottom: 15),
                          child: GestureDetector(
                            child: PopularDoctorPD(
                              doctor: allDoctors[index],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => DoctorProfilePagePD(
                                        doctor: allDoctors[index],
                                        patient: widget.userData,
                                      )));
                            },
                          ),
                        ),
                        onTap: () async {},
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
