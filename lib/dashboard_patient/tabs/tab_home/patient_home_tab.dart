import 'dart:convert';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_page.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/tabs/tab_home/seach_result.dart';
import 'package:medilife_patient/dashboard_patient/widgets/category_box.dart';
import 'package:medilife_patient/dashboard_patient/widgets/popular_doctor.dart';
import 'package:medilife_patient/dashboard_patient/doctor/upcoming_appointments.dart';
import 'package:medilife_patient/dashboard_patient/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/dashboard_patient/lab_test/display_lab_test.dart';
import 'package:medilife_patient/dashboard_patient/book-now/book_now.dart';
import 'package:medilife_patient/dashboard_patient/tabs/tab_home/show_all.dart';
import 'all_categories_doctor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TabHomePatient extends StatefulWidget {
  const TabHomePatient({Key? key, required this.userData}) : super(key: key);
  final userData;

  @override
  _TabHomePatientState createState() => _TabHomePatientState();
}

class _TabHomePatientState extends State<TabHomePatient> {
  int currentPos = 0;

  // final List<String> imgList = [
  //   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  //   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  //   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  //   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  //   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  //   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  // ];
  final List<String> imgList2 = [];

  var dataAllDoctors;
  var dataSpeciality;
  var upcomimgAppointments;
  var advertisementList;
  var speciality;

  bool specialityF = true;
  bool advertisementF = true;
  bool upcomingF = true;
  bool dataF = false;

  var dataSearch;
  bool serachButton = false;
  bool flagPopularDoctor = false;

  TextEditingController _controllerSearch = TextEditingController();

  Future<void> searchDoctor(String name) async {
    if (mounted) {
      setState(() {
        serachButton = true;
      });
    }
    bool? fullName;
    if (name.length == 1) {
      fullName = false;
    } else {
      fullName = true;
    }
    dataF = true;
    var API1 =
        'https://cabeloclinic.com/website/medlife/php_auth_api/search_doctor_name_appointment_api.php';
    var API2 =
        'https://cabeloclinic.com/website/medlife/php_auth_api/characterwise_doctor_list_api.php';
    // print('date tra...2.....................${name}');
    Map<String, dynamic> body1 = {'doctor_name': name};
    Map<String, dynamic> body2 = {'character': name};

    http.Response response = await http
        .post(Uri.parse(fullName ? API1 : API2), body: fullName ? body1 : body2)
        .then((value) => value)
        .catchError((error) => print(" Failed to getAllAssitents: $error"));
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          dataF = true;
        });
      }

      dataSearch = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          serachButton = false;
        });
      }
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SearchResult(
                data: dataSearch,
                userData: widget.userData,
              )));
    } else {}
  }

  Future<void> getSpeciality() async {
    if (mounted) {
      setState(() {
      });
    }
    var API = 'patient_specialist_api.php';
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API))
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      speciality = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          specialityF = false;
        });
      }
    } else {}
  }

  Future<void> getUpcomingAppointments() async {
    if (mounted) {
      setState(() {
      });
    }
    var API = 'upcoming_appointment_patient_api.php';
    Map<String, dynamic> body = {'patient_id': widget.userData['user_id']};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      upcomimgAppointments = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          upcomingF = false;
        });
      }
    } else {}
  }

  Future<void> getAdvertisement() async {
    if (mounted) {
      setState(() {
        imgList2.clear();
      });
    }

    var API = 'advertisement_api.php';
    http.Response response = await http
        .get(Uri.parse(API_BASE_URL + API))
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      advertisementList = jsonDecode(response.body.toString());
      for (int i = 0; i < advertisementList.length; i++) {
        imgList2.add(advertisementList[i]['image']);
      }
      if (mounted) {
        setState(() {
          advertisementF = false;
        });
      }
    } else {}
  }

  Future<void> getAllDoctors() async {
    flagPopularDoctor = true;
    if (mounted) {
      setState(() {
      });
    }
    var API = 'popular_doctors_api.php';
    http.Response response = await http
        .get(Uri.parse(API_BASE_URL + API))
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      dataAllDoctors = jsonDecode(response.body.toString());
      flagPopularDoctor = false;
    } else {}
  }

  Future<void> getSpecialist() async {
    if (mounted) {
      setState(() {
      });
    }
    var API = 'popular_doctors_api.php';
    http.Response response = await http
        .get(Uri.parse(API_BASE_URL + API))
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      dataSpeciality = jsonDecode(response.body.toString());
    } else {}
  }

  callApis() {
    getUpcomingAppointments();
    getSpeciality();
    getAdvertisement();
    getAllDoctors();
    getSpecialist();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingAppointments();
    getSpeciality();
    getAdvertisement();
    getAllDoctors();
    getSpecialist();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    _controllerSearch.clear();
    imgList2.clear();
    specialityF = true;
    advertisementF = true;
    upcomingF = true;
    callApis();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    callApis();
    if (mounted) {
      setState(() {

      });
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
        child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropMaterialHeader(color: Colors.green),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            controller: _refreshController,
            child: getBody()),
      ),
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            // onTap: () {
            //   Navigator.of(context).push(MaterialPageRoute(
            //       builder: (_) => BookingScreenPD(
            //             familyMember: familyMembers[0],
            //             doctor: doctors[0],
            //             totalConsult: '0',
            //             memberType: 1,
            //           )));
            // },
            child: Center(
                child: Text(
              "Let's Find Your Doctor",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width * .8,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerSearch,
                  onSubmitted: (value) {
                    searchDoctor(_controllerSearch.text);
                  },
                  onChanged: (v) {
                    if (_controllerSearch.text.length == 0) {
                      setState(() {
                        serachButton = false;
                      });
                    }
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.blue),
                      border: InputBorder.none,
                      hintText: "Search doctor by name or First character",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .12,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                    onPressed: () {
                      searchDoctor(_controllerSearch.text);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (_) => SearchResult(
                      //           data: dataSearch,
                      //           userData: widget.userData,
                      //         )));
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          serachButton
              ? Center(child: CircularProgressIndicator())
              : Container(),
          SizedBox(height: 25),
          Container(
              child: const Text(
            "Upcoming Appointments",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          )),
          SizedBox(height: 10),
          upcomingF == true
              ? Center(child: CircularProgressIndicator())
              : upcomimgAppointments.length == 0
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                              width: MediaQuery.of(context).size.width * .9,
                              child: Image.asset('assets/appointments.png'),
                            ),
                            Text('No Upcoming Appointments'),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 170,
                      child: FutureBuilder(
                          future: getUpcomingAppointments(),
                          builder: (context, snapsht) {
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: upcomimgAppointments.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: UpComingAppointments(
                                      doctor: upcomimgAppointments[index],
                                    ),
                                    onTap: () async {},
                                  );
                                });
                          })),
          // SingleChildScrollView(
          //   padding: EdgeInsets.only(bottom: 5),
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       UpComingAppointments(
          //         doctor: doctors[0],
          //       ),
          //       UpComingAppointments(
          //         doctor: doctors[1],
          //       ),
          //       UpComingAppointments(
          //         doctor: doctors[2],
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          advertisementF
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Container(
                        height: 150,
                        width: double.infinity,
                        child: CarouselSlider(
                          options: CarouselOptions(
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                if (mounted) {
                                  setState(() {
                                    currentPos = index;
                                  });
                                }
                              }),
                          items: imgList2
                              .map((item) => Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: MyImageView(item),
                                  ))
                              .toList(),
                        )),
                    Positioned(
                      bottom: 10,
                      left: MediaQuery.of(context).size.width * .4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList2.map((url) {
                          int index = imgList2.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPos == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.width * .30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * .18,
                                  width:
                                      MediaQuery.of(context).size.width * .18,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: .1,
                                      ),
                                    ),
                                    child:
                                        Image.asset('assets/images/male.png'),
                                  )),
                              SizedBox(height: 5),
                              Text(
                                'Appointment Now',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BookNow(
                                      userData: widget.userData,
                                    )));
                          },
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * .1),
                        GestureDetector(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.asset(
                                    'assets/images/medical-record.png'),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Book Lab Test',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => DisplayLabTest(
                                    patientId: widget.userData['user_id'])));
                          },
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              child: Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          )),
          SizedBox(
            height: 5,
          ),
          specialityF
              ? Center(child: CircularProgressIndicator())
              : speciality == ''
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      height: 170,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: speciality.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Container(
                                height: 100,
                                width: 130,
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 100,
                                        child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/loading.gif',
                                            image: speciality[index]['image']),
                                      ),
                                      // SizedBox(
                                      //   height: 80,
                                      //   width: 100,
                                      //   child: Image.network(speciality[index]['image']),),
                                      Text(
                                        speciality[index]['speciality'],
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => AllCategoriesDoctor(
                                          title: speciality[index]
                                              ['speciality'],
                                          userData: widget.userData,
                                          searchKey: speciality[index]
                                              ['speciality'],
                                        )));
                              },
                            );
                          })),

          // SizedBox(
          //   height: 25,
          // ),
          // Container(
          //   margin: EdgeInsets.only(right: 15),
          //   padding: EdgeInsets.only(left: 5, top: 15),
          //   width: MediaQuery.of(context).size.width * .9,
          //   height: 1,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.white,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey.withOpacity(0.4),
          //         spreadRadius: 1,
          //         blurRadius: 1,
          //         offset: Offset(1, 1), // changes position of shadow
          //       ),
          //     ],
          //   ),
          //   child: SingleChildScrollView(
          //     padding: EdgeInsets.only(bottom: 5),
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: [
          //         GestureDetector(
          //           child: CategoryBoxPD(
          //             title: "Heart",
          //             icon: Icons.favorite,
          //             color: Colors.red,
          //           ),
          //           onTap: () {
          //             Navigator.of(context).push(
          //                 MaterialPageRoute(builder: (_) => DoctorPagePD()));
          //           },
          //         ),
          //         GestureDetector(
          //           child: CategoryBoxPD(
          //             title: "Medical",
          //             icon: Icons.local_hospital,
          //             color: Colors.blue,
          //           ),
          //           onTap: () {
          //             Navigator.of(context).push(
          //                 MaterialPageRoute(builder: (_) => DoctorPagePD()));
          //           },
          //         ),
          //         GestureDetector(
          //           child: CategoryBoxPD(
          //             title: "Dental",
          //             icon: Icons.details_rounded,
          //             color: Colors.purple,
          //           ),
          //           onTap: () {
          //             Navigator.of(context).push(
          //                 MaterialPageRoute(builder: (_) => DoctorPagePD()));
          //           },
          //         ),
          //         GestureDetector(
          //           child: CategoryBoxPD(
          //             title: "Healing",
          //             icon: Icons.healing_outlined,
          //             color: Colors.green,
          //           ),
          //           onTap: () {
          //             Navigator.of(context).push(
          //                 MaterialPageRoute(builder: (_) => DoctorPagePD()));
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Container(
                  child: Text(
                "Nearby Doctors",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ShowAll(
                            title: 'All Nearby Doctors',
                            userData: widget.userData,
                            data: dataAllDoctors,
                          )));
                },
                child: Container(
                    child: Text(
                  "Show All",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                )),
              ),
            ],
          ),
          SizedBox(height: 20),
          flagPopularDoctor
              ? Center(child: CircularProgressIndicator())
              : dataAllDoctors[0]['status'] == '0'
                  ? Center(child: Text('Sorry No Nearby Doctor Found !'))
                  : Container(
                      height: 170,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: dataAllDoctors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: PopularDoctorPD(
                                doctor: dataAllDoctors[index],
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => DoctorProfilePagePD(
                                        doctor: dataAllDoctors[index],
                                        patient: widget.userData)));
                              },
                            );
                          })),
          SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Container(
                  child: Text(
                "Popular Doctors",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              )),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ShowAll(
                            title: 'All Popular Doctors',
                            userData: widget.userData,
                            data: dataAllDoctors,
                          )));
                },
                child: Text(
                  "Show All",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          flagPopularDoctor
              ? Center(child: CircularProgressIndicator())
              : dataAllDoctors[0]['status'] == '0'
                  ? Center(child: Text('Sorry No Popular Doctor Found !'))
                  : Container(
                      height: 170,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: dataAllDoctors.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: PopularDoctorPD(
                                doctor: dataAllDoctors[index],
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => DoctorProfilePagePD(
                                          doctor: dataAllDoctors[index],
                                          patient: widget.userData,
                                        )));
                              },
                            );
                          })),

          SizedBox(
            height: 20,
          ),
          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.all(20),
          //   height: 160,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(30),
          //     image: DecorationImage(
          //       image: NetworkImage("https://media.istockphoto.com/vectors/electronic-health-record-concept-vector-id1299616187?k=20&m=1299616187&s=612x612&w=0&h=gmUf6TXc8w6NynKB_4p2TzL5PVIztg9UK6TOoY5ckMM="),
          //       fit: BoxFit.cover,)
          //   ),
          // ),
          // SizedBox(height: 20,),
        ]),
      ),
    );
  }
}

class MyImageView extends StatelessWidget {
  String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: NetworkImage(imgPath),
          )),
    );
  }
}
