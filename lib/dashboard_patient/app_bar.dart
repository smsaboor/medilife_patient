import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/api/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBarPD extends StatefulWidget {
  const CustomAppBarPD({Key? key, required this.isleading}) : super(key: key);
  final isleading;
  @override
  _CustomAppBarPDState createState() => _CustomAppBarPDState();
}

class _CustomAppBarPDState extends State<CustomAppBarPD> {
  var data;
  bool uplaodImage = true;
  String? userName;
  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final user = preferences.getString('userDetails');
    userName = preferences.getString('userName');
    setState(() {
      data = jsonStringToMap(user!);
    });
    _getImgeUrl(data['user_id']);
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

  void _getImgeUrl(String doctorId) async {
    fetchImageData = await ApiEditProfiles.getImgeUrl(doctorId);
    if (fetchImageData[0]['image'] !='') {
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
              Text(
                userName == null ? '' : '$userName ',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        uplaodImage?const Padding(
          padding: EdgeInsets.all(8.0),
          child: AvatarImagePD(
            "https://p.kindpng.com/picc/s/376-3768467_transparent-healthcare-icon-png-patient-info-icon-png.png",
            radius: 35,
            height: 40,
            width: 40,
          ),
        ):fetchImageData[0]['image']==null
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
    );
  }
}
