import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/core/constatnts/components.dart';
import 'package:flutter_package1/data_connection_checker/connectivity.dart';
import 'package:medilife_patient/core/internet_error.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/api/api.dart';
import 'package:medilife_patient/dashboard_patient/custom_widgtes/app_bar.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/about.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/change_password.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/edit_profile/edit_profile.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/privacy_policy.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/terms_notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medilife_patient/screens/auth/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/widget/profile_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:medilife_patient/core/constatnts/urls.dart';
import 'package:flutter_package1/bottom_nav/bottom_nav_cubit.dart';

class MoreTabPD extends StatefulWidget {
  const MoreTabPD({super.key, required this.userData, required this.userID});
  final userID;
  final userData;

  @override
  State<MoreTabPD> createState() => _MoreTabPDState();
}

class _MoreTabPDState extends State<MoreTabPD> {
  var data;
  bool uplaodImage = true;
  bool flagAccess = true;
  var fetchUserData;
  String? userName;

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final user = preferences.getString('userDetails');
    userName = preferences.getString('userName');
    if (mounted) {
      setState(() {
        data = jsonStringToMap(user!);
      });
    }
    _getImgeUrl(data == null ? '' : data['user_id']);
  }

  jsonStringToMap(String data) {
    List<String> str = data
        .replaceAll("{", "")
        .replaceAll("}", "")
        .replaceAll("\"", "")
        .replaceAll("'", "")
        .split(",");
    Map<String, dynamic> result = {};
    for (int i = 0; i < str.length; i++) {
      List<String> s = str[i].split(":");
      result.putIfAbsent(s[0].trim(), () => s[1].trim());
    }
    return result;
  }

  getUserData() async {
    _getImgeUrl(widget.userID);
    if (mounted) {
      setState(() {});
    }
    var API = '${API_BASE_URL}patient_fetch_profile_api.php';
    Map<String, dynamic> body = {
      'patient_id': widget.userID,
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to fetchProfileData: $error"));
    if (response.statusCode == 200) {
      fetchUserData = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          flagAccess = false;
        });
      }
    } else {}
  }

  String? imageUrl;

  var fetchImageData;

  void _getImgeUrl(String doctorId) async {
    fetchImageData = await ApiEditProfiles.getImgeUrl(doctorId);
    if (fetchImageData[0]['image'] != '') {
      if (mounted) {
        setState(() {
          uplaodImage = false;
          imageUrl = fetchImageData[0]['image'];
        });
      }
    } else {
      if (mounted) {
        setState(() {
          uplaodImage = false;
          imageUrl = AppUrls.user;
        });
      }
    }
  }

  void getApiData() async {
    await getData();
    await getUserData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(414, 896),
    );
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) => EditProfileDD(
                                  button: 'Save',
                                  id: data == null ? '' : data['user_id'],
                                )))
                        .then((value) {
                          getData();
                      getUserData();
                      getAppBar();
                    });
                  },
                  child: uplaodImage
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : fetchImageData[0]['image'] != ''
                          ? AvatarImagePD(
                              fetchImageData[0]['image'],
                              radius: kSpacingUnit.w * 5,
                            )
                          : AvatarImagePD(
                              AppUrls.user,
                              radius: kSpacingUnit.w * 5,
                            ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: uplaodImage ? Colors.blue : Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: (ScreenUtil()
                            .setSp(kSpacingUnit.w * 1.5)
                            .toDouble()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            '${userName == null ? '' : (userName!.length > 25 ? userName!.substring(0, 25) + '...' : userName! ?? '')}',
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          flagAccess
              ? Container(
                  height: kSpacingUnit.w * 4,
                  width: kSpacingUnit.w * 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Center(
                    child: Text(
                      'Please wait..',
                      style: kButtonTextStyle,
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (_) => EditProfileDD(
                                  button: 'Save',
                                  id: data == null ? '' : data['user_id'],
                                )))
                        .then((value) {
                          getData();
                      getUserData();
                      getAppBar();
                    });
                  },
                  child: Container(
                    height: kSpacingUnit.w * 4,
                    width: kSpacingUnit.w * 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                      color: Colors.amber,
                    ),
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: kButtonTextStyle,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        profileInfo,
        // themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );
    return BlocConsumer<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state == NetworkState.initial) {
          showToast(msg: TX_OFFLINE);
        } else if (state == NetworkState.gained) {
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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              bottomOpacity: 0.0,
              titleSpacing: 0,
              elevation: 0.0,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userName == null ? '' : '$userName',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                uplaodImage
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: AvatarImagePD(
                          "https://p.kindpng.com/picc/s/376-3768467_transparent-healthcare-icon-png-patient-info-icon-png.png",
                          radius: 35,
                          height: 40,
                          width: 40,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AvatarImagePD(
                          fetchImageData[0]['image'],
                          radius: 35,
                          height: 40,
                          width: 40,
                        ),
                      )
              ],
              title: Image.asset(
                'assets/img_2.png',
                width: 150,
                height: 90,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: kSpacingUnit.w * 1),
                  header,
                  SizedBox(height: kSpacingUnit.w * 3),
                  GestureDetector(
                    child: const ProfileListItem(
                      icon: Icons.password,
                      text: 'Change Password',
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ChangePassword(
                                mobile: data == null ? '' : data['number'],
                                userType: data == null ? '' : data['user_type'],
                              )));
                    },
                  ),
                  GestureDetector(
                    child: const ProfileListItem(
                      icon: LineAwesomeIcons.question_circle,
                      text: 'About Medilipse',
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => About()));
                    },
                  ),
                  GestureDetector(
                    child: const ProfileListItem(
                      icon: LineAwesomeIcons.user_shield,
                      text: 'Privacy Policy',
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => PrivacyPolicy()));
                    },
                  ),
                  GestureDetector(
                    child: const ProfileListItem(
                      icon: LineAwesomeIcons.book,
                      text: 'Term & Condition',
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TermsOfServices()));
                    },
                  ),
                  GestureDetector(
                    child: const ProfileListItem(
                      icon: LineAwesomeIcons.alternate_sign_out,
                      text: 'Logout',
                      hasNavigation: false,
                    ),
                    onTap: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.setBool('isLogin', false);
                      BlocProvider.of<NavigationCubit>(context)
                          .setNavBarItem(0);
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen(),
                        ),
                        (route) => false,
                      );
                      // Navigator.pushReplacementNamed(context, RouteGenerator.signIn);
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state == NetworkState.lost) {
          return const InternetError(text: TX_LOST_INTERNET);
        } else {
          return const InternetError(text: 'error');
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        titleSpacing: 0,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data == null ? '' : '${data['name']} ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          uplaodImage
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AvatarImagePD(
                    "https://p.kindpng.com/picc/s/376-3768467_transparent-healthcare-icon-png-patient-info-icon-png.png",
                    radius: 35,
                    height: 40,
                    width: 40,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AvatarImagePD(
                    fetchImageData[0]['image'],
                    radius: 35,
                    height: 40,
                    width: 40,
                  ),
                )
        ],
        title: Image.asset(
          'assets/img_2.png',
          width: 150,
          height: 90,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: kSpacingUnit.w * 1),
            header,
            SizedBox(height: kSpacingUnit.w * 3),
            GestureDetector(
              child: const ProfileListItem(
                icon: Icons.password,
                text: 'Change Password',
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChangePassword(
                          mobile: data == null ? '' : data['number'],
                          userType: data == null ? '' : data['user_type'],
                        )));
              },
            ),
            GestureDetector(
              child: const ProfileListItem(
                icon: LineAwesomeIcons.question_circle,
                text: 'About Medilipse',
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => About()));
              },
            ),
            GestureDetector(
              child: const ProfileListItem(
                icon: LineAwesomeIcons.user_shield,
                text: 'Privacy Policy',
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => PrivacyPolicy()));
              },
            ),
            GestureDetector(
              child: const ProfileListItem(
                icon: LineAwesomeIcons.book,
                text: 'Term & Condition',
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => TermsOfServices()));
              },
            ),
            GestureDetector(
              child: const ProfileListItem(
                icon: LineAwesomeIcons.alternate_sign_out,
                text: 'Logout',
                hasNavigation: false,
              ),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setBool('isLogin', false);
                BlocProvider.of<NavigationCubit>(context).setNavBarItem(0);
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
                // Navigator.pushReplacementNamed(context, RouteGenerator.signIn);
              },
            ),
          ],
        ),
      ),
    );
  }

  getAppBar() {
    return const PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: CustomAppBar(
        isleading: false,
      ),
    );
  }
}
