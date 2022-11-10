import 'package:circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_package1/bottom_nav/bottom_nav_cubit.dart';
import 'package:medilife_patient/dashboard_patient/tabs/tab_hom/patient_home_tab.dart';
import 'package:medilife_patient/dashboard_patient/upcomming_appointments.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medilife_patient/dashboard_patient/transaction_tab/transaction.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/more_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_package1/bottom_nav/nav_bar_items.dart';

class PatientDashboard extends StatefulWidget {
  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard>
    with TickerProviderStateMixin {
  int currentPage = 0;
  int tabIndex = 0;
  var data;

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final user = preferences.getString('userDetails');
    if (mounted) {
      setState(() {
        data = jsonStringToMap(user!);
      });
    }
  }

  jsonStringToMap(String data) {
    Map<String, dynamic> result = {};
    try {
      List<String> str = data
          .replaceAll("{", "")
          .replaceAll("}", "")
          .replaceAll("\"", "")
          .replaceAll("'", "")
          .split(",");
      for (int i = 0; i < str.length; i++) {
        List<String> s = str[i].split(":");
        result.putIfAbsent(s[0].trim(), () => s[1].trim());
      }
    } catch (e) {
    }
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final viewPadding = MediaQuery.of(context).viewPadding;
    double barHeight;
    double barHeightWithNotch = 67;
    double arcHeightWithNotch = 67;

    if (size.height > 700) {
      barHeight = 70;
    } else {
      barHeight = size.height * 0.1;
    }

    if (viewPadding.bottom > 0) {
      barHeightWithNotch = (size.height * 0.07) + viewPadding.bottom;
      arcHeightWithNotch = (size.height * 0.075) + viewPadding.bottom;
    }

    return Scaffold(
      body: data == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            if (state.navbarItem == NavbarItem.index1) {
              return TabHomePatient(userData: data);
            } else if (state.navbarItem == NavbarItem.index2) {
              return UpcomingApointments(userData: data);
            } else if (state.navbarItem == NavbarItem.index3) {
              return TransactionTabPD(userData: data, doctor_id: data['user_id']);
            }
            else if (state.navbarItem == NavbarItem.index4) {
              return MoreTabPD(userData: data, userID: data['user_id']);
            }
            return Container();
          }),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return CircleBottomNavigationBar(
            initialSelection: currentPage,
            barHeight: viewPadding.bottom > 0 ? barHeightWithNotch : barHeight,
            arcHeight: viewPadding.bottom > 0 ? arcHeightWithNotch : barHeight,
            itemTextOff: viewPadding.bottom > 0 ? 0 : 1,
            itemTextOn: viewPadding.bottom > 0 ? 0 : 1,
            circleOutline: 15.0,
            shadowAllowance: 0.0,
            circleSize: 50.0,
            blurShadowRadius: 50.0,
            circleColor: Colors.blue,
            activeIconColor: Colors.white,
            inactiveIconColor: Colors.grey,
            tabs: getTabsData(),
            onTabChangedListener: (index) {
              if (index == 0) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.index1);
              } else if (index == 1) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.index2);
              } else if (index == 2) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.index3);
              } else if (index == 3) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.index4);
              }
            },
          );
        }
      ),
    );
  }

  getBody(var patientData, int currentPage, var data) {
    switch (currentPage) {
      case 0:
        return TabHomePatient(userData: patientData);
      case 1:
        return UpcomingApointments(userData: data);
      case 2:
        return TransactionTabPD(userData: data, doctor_id: data['user_id']);
        break;
      case 3:
        return MoreTabPD(userData: data, userID: data['user_id']);
    }
  }
}

List<TabData> getTabsData() {
  return [
    TabData(
      icon: Icons.home,
      iconSize: 25.0,
      title: 'Home',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    TabData(
      icon: Icons.library_books,
      iconSize: 25,
      title: 'Appointment',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    TabData(
      icon: LineAwesomeIcons.history,
      iconSize: 25,
      title: 'Transactions',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
    TabData(
      icon: Icons.perm_identity,
      iconSize: 25,
      title: 'Profile',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    ),
  ];
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Home',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Appointment',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Earning',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Alarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profile ',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
