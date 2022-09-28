import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/widgets/popular_doctor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookNow extends StatefulWidget {
  const BookNow({Key? key,required this.userData}) : super(key: key);
final userData;
  @override
  State<BookNow> createState() => _BookNowState();
}

class _BookNowState extends State<BookNow> {
  var dataAllDoctors;
  bool dataAllDoctorsF=true;

  Future<void> getAllDoctors() async {

    var API = 'sorting_doctor_detail_api.php';
    http.Response response = await http
        .get(Uri.parse(API_BASE_URL + API))
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      dataAllDoctors = jsonDecode(response.body.toString());
      print('444444445554444${dataAllDoctors}');
      if (mounted) {
        setState(() {
          dataAllDoctorsF=false;
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


  callApis(){
    getAllDoctors();
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (mounted) {
      setState(() {
        dataAllDoctorsF=true;
      });
    }
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

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
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Doctor'),
        centerTitle: true,
      ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: 	WaterDropMaterialHeader(color: Colors.blue),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _refreshController,
          child: getBody()),
    );
  }

  getBody(){
    return SingleChildScrollView(
      child: Column(
        children: [
          dataAllDoctorsF?Center(child: CircularProgressIndicator()):dataAllDoctors == null
              ? Center(child: Text('No Data'))
              : ListView.builder(
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
              }),
        ],
      ),
    );
  }
}
