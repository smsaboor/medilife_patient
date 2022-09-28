import 'dart:convert';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/api/api.dart';
import 'package:medilife_patient/dashboard_patient/custom_widgtes/app_bar.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/about.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/change_password.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/edit_profile/edit_profile.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/privacy_policy.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/terms_notes.dart';
import 'package:medilife_patient/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:medilife_patient/screens/auth/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/widget/profile_list_item.dart';
import 'package:http/http.dart' as http;

class MoreTabPD extends StatefulWidget {
  MoreTabPD({required this.userData, required this.userID});

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

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final user = preferences.getString('userDetails');
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
      setState(() {
      });
    }
    var API =
        'https://cabeloclinic.com/website/medlife/php_auth_api/patient_fetch_profile_api.php';
    Map<String, dynamic> body = {
      'patient_id': widget.userID,
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to fetchProfileData: $error"));
    print('1...............................${response.body}');
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
          imageUrl=fetchImageData[0]['image'];
        });
      }
    } else {
      if (mounted) {
        setState(() {
          uplaodImage = false;
          imageUrl='https://www.kindpng.com/picc/m/198-1985282_doctor-profile-icon-png-transparent-png.png';
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
      designSize: Size(414, 896),
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
                      getUserData();
                      getAppBar();
                    });
                  },
                  child: uplaodImage
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : fetchImageData[0]['image'] != ''
                          ? AvatarImagePD(
                              fetchImageData[0]['image'],
                              radius: kSpacingUnit.w * 5,
                            )
                          : AvatarImagePD(
                              'https://www.kindpng.com/picc/m/198-1985282_doctor-profile-icon-png-transparent-png.png',
                              radius: kSpacingUnit.w * 5,
                            ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
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
            '${data == null ? '' : data['name']}',
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
                      getUserData();
                      getAppBar();
                    });
                  },
                  child: Container(
                    height: kSpacingUnit.w * 4,
                    width: kSpacingUnit.w * 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
                      color: Theme.of(context).accentColor,
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

    var themeSwitcher = ThemeSwitcher(
      builder: (context) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState:
              ThemeModelInheritedNotifier.of(context).theme == Brightness.light
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kLightTheme),
            child: Icon(
              LineAwesomeIcons.sun,
              size: (ScreenUtil().setSp(kSpacingUnit.w * 3)).toDouble(),
            ),
          ),
          secondChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme),
            child: Icon(
              LineAwesomeIcons.moon,
              size: (ScreenUtil().setSp(kSpacingUnit.w * 3)).toDouble(),
            ),
          ),
        );
      },
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          uplaodImage
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AvatarImagePD(
                    "https://www.kindpng.com/picc/m/198-1985282_doctor-profile-icon-png-transparent-png.png",
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
              child: ProfileListItem(
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
            // GestureDetector(
            //   child: ProfileListItem(
            //     icon: LineAwesomeIcons.cog,
            //     text: 'Settings',
            //   ),
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (_) => SettingDD(
            //               doctorId: data == null ? '' : data['user_id'],
            //               userData: widget.userData,
            //             )));
            //   },
            // ),
            // GestureDetector(
            //   child: ProfileListItem(
            //     icon: LineAwesomeIcons.question_circle,
            //     text: 'Manage Members',
            //   ),
            //   onTap: () {
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (_) => DisplayFamilyMembers(
            //             patientId: data == null ? '' : data['user_id'])));
            //   },
            // ),
            GestureDetector(
              child: ProfileListItem(
                icon: LineAwesomeIcons.question_circle,
                text: 'About Medilipse',
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => About()));
              },
            ),
            GestureDetector(
              child: ProfileListItem(
                icon: LineAwesomeIcons.user_shield,
                text: 'Privacy Policy',
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => PrivacyPolicy()));
              },
            ),
            GestureDetector(
              child: ProfileListItem(
                icon: LineAwesomeIcons.book,
                text: 'Term & Condition',
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => TermsOfServices()));
              },
            ),
            GestureDetector(
              child: ProfileListItem(
                icon: LineAwesomeIcons.alternate_sign_out,
                text: 'Logout',
                hasNavigation: false,
              ),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                preferences.setBool('isLogin', false);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
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
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: CustomAppBar(
        isleading: false,
      ),
    );
  }
}
