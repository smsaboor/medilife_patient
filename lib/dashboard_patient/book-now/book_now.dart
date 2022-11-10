import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/widgets/popular_doctor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_package1/loading/loading_card_list.dart';
import 'package:flutter_package1/loading/loading_card.dart';
import 'package:flutter_package1/loading/loading1.dart';
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
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    if (mounted) {
      setState(() {
        dataAllDoctorsF=true;
      });
    }
    callApis();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
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
        title: const Text('Select Doctor'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: 	const WaterDropMaterialHeader(color: Colors.blue),
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
          dataAllDoctorsF? const LoadingCardList():dataAllDoctors[0]['status']=='0'
              ? const Center(child: Text('No Doctor available'))
              : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
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
