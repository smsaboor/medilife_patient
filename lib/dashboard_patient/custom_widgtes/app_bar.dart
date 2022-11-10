import 'package:medilife_patient/core/constatnts/assets.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/api/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medilife_patient/core/constatnts/urls.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key, required this.isleading}) : super(key: key);
  final isleading;
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  var data;
  bool uplaodImage = true;

  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final user = preferences.getString('userDetails');
    setState(() {
      data = jsonStringToMap(user!);
    });
    _getImageUrl(data['user_id']);
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

  var fetchImageData;

  void _getImageUrl(String doctorId) async {
    fetchImageData = await ApiEditProfiles.getImgeUrl(doctorId);
    if (fetchImageData[0]['image'] != '') {
      setState(() {
        uplaodImage = false;
      });
    } else {
      setState(() {
        uplaodImage = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: widget.isleading
          ? Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24, // Changing Drawer Icon Size
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            )
          : null,
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
              Row(children: [
                const Text(
                  '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  data == null ? '' : '${data['name']} ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],),

            ],
          ),
        ),
        uplaodImage
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: AvatarImagePD(
                  AppUrls.user,
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
        AppAssets.logo,
        width: 150,
        height: 90,
      ),
    );
  }
}
