import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medilife_patient/core/constants.dart';
class ApiEditProfiles{
  static var updateProfileData;
  static updateProfile({String? doctorid,String? name,String? emeNo,String? degree,String? lang,String? lic_no,
    String? exper,String? spec,String? expe,String? address
  }) async {
    var API = '${API_BASE_URL}update_profile_api.php';
    Map<String, dynamic> body = {
      'doctor_id': doctorid,
      'name': name,
      'emergency_number': emeNo,
      'degree': degree,
      'language': lang,
      'experience': expe,
      'speciality': spec,
      'licence_no': lic_no,
      'address': address,
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to updateProfile: $error"));
    if (response.statusCode == 200) {
      updateProfileData = jsonDecode(response.body.toString());
    } else {}
  }

static bool fetchImageF=true;
  static dynamic getImgeUrl(String doctorId)async{
    var fetchImageData;
    var API = '${API_BASE_URL}patient_fetch_image_api.php';
    Map<String, dynamic> body = {'patient_id': doctorId};
    http.Response response = await http
        .post(Uri.parse(API),body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getAllAssitents: $error"));
    if (response.statusCode == 200) {
      fetchImageData = jsonDecode(response.body.toString());
      fetchImageF=false;
    } else {}
    return fetchImageData;
  }
}