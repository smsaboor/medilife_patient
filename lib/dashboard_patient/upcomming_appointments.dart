import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_package1/loading/loading_card_list.dart';
import 'package:medilife_patient/core/constatnts/components.dart';
import 'package:medilife_patient/core/internet_error.dart';
import 'package:medilife_patient/dashboard_patient/app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/dashboard_patient/doctor/upcoming_appointments2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_package1/data_connection_checker/connectivity.dart';

class UpcomingApointments extends StatefulWidget {
  const UpcomingApointments({Key? key, required this.userData})
      : super(key: key);
  final userData;

  @override
  _UpcomingApointmentsState createState() => _UpcomingApointmentsState();
}

class _UpcomingApointmentsState extends State<UpcomingApointments> {
  var upcomimgAppointments;

  bool upcomingF = true;

  Future<void> getUpcomingAppointments() async {
    if (mounted) {
      setState(() {});
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUpcomingAppointments();
  }

  callApis() {
    getUpcomingAppointments();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    upcomingF = true;
    callApis();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    callApis();
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state == NetworkState.initial) {
          showToast(msg: TX_OFFLINE);
        } else if (state == NetworkState.gained) {
          callApis();
          showToast(msg: TX_ONLINE);
        } else if (state == NetworkState.lost) {
          showToast(msg: TX_OFFLINE);
        } else {
          showToast(msg: 'error');
        }
      },
      builder: (context, state) {
        if (state == NetworkState.initial) {
          return const InternetError(text: TX_CHECK_INTERNET);
        } else if (state == NetworkState.gained) {
          return Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: CustomAppBarPD(
                isleading: false,
              ),
            ),
            body: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: const WaterDropMaterialHeader(
                    color: Colors.white, backgroundColor: Colors.blue),
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                controller: _refreshController,
                child: getBody()),
          );
        } else if (state == NetworkState.lost) {
          return const InternetError(text: TX_LOST_INTERNET);
        } else {
          return const InternetError(text: 'error');
        }
      },
    );
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBarPD(
          isleading: false,
        ),
      ),
      body: SafeArea(
        child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: const WaterDropMaterialHeader(
                color: Colors.white, backgroundColor: Colors.blue),
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            controller: _refreshController,
            child: getBody()),
      ),
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            title: const Text('Appointments'),
          ),
          const SizedBox(
            height: 20,
          ),
          upcomingF == true
              ? const LoadingCardList()
              : upcomimgAppointments.length == 0
                  ? const Center(child: Text('No Upcoming Appointment Found !'))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: upcomimgAppointments.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 8, bottom: 15),
                            child: UpComingAppointments2(
                              doctor: upcomimgAppointments[index],
                            ),
                          ),
                          onTap: () async {},
                        );
                      })
        ],
      ),
    );
  }
}
