
import 'package:medilife_patient/dashboard_patient/upcomming_appointments.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class PatientHomeTab extends StatefulWidget {
  const PatientHomeTab({Key? key}) : super(key: key);

  @override
  _PatientHomeTabState createState() => _PatientHomeTabState();
}

class _PatientHomeTabState extends State<PatientHomeTab> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                new SliverAppBar(
                  centerTitle: true,
                  leading: GestureDetector(
                      child: Icon(
                        Icons.list_outlined,
                        color: Colors.purple,
                        size: 28,
                      ),
                      onTap: () {}),
                  title: Text('Appointments',
                      style: GoogleFonts.mulish(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                  actions: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 6.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.account_circle,
                          size: 24.0,
                          color: Colors.purple,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                  automaticallyImplyLeading: false,
                  elevation: 4.0,
                  backgroundColor: Colors.white,
                  floating: true,
                  pinned: true,
                  snap: true,
                  bottom: TabBar(
                    indicatorColor: Colors.red,
                    isScrollable: false,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: "Upcoming",
                      ),
                      Tab(
                        text: "Pending",
                      ),
                      Tab(
                        text: "Completed",
                      ),
                    ],
                    labelColor: Colors.black,
                    unselectedLabelStyle: GoogleFonts.mulish(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    labelStyle: GoogleFonts.mulish(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    indicator: MaterialIndicator(
                      color: Colors.purple,
                      height: 5,
                      topLeftRadius: 8,
                      topRightRadius: 8,
                      horizontalPadding: 50,
                      tabPosition: TabPosition.bottom,
                    ),
                  ),
                ),
              ];
            },
            body: _tabBarViewWorld()),
      ),
    );
  }

  Widget _tabBarViewWorld() {
    debugPrint("in ........................_tabBarView");
    return TabBarView(controller: _tabController, children: [
     UpcomingApointments(userData: '1',),
      Container(
        child: const Center(
          child: Text(
            'Pending Tab ',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Container(
        child: const Center(
          child: Text(
            'Completed Tab ',
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ]);
  }
}
