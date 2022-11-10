import 'dart:convert';
import 'package:flutter_package1/CustomFormField.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:flutter_package1/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/widgets/avatar_image.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/edit_profile/api/api.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/edit_profile/image.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/edit_profile/model_profile.dart';
import 'package:medilife_patient/dashboard_patient/more_tab/edit_profile/profile_servicee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as Dio;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';

class EditProfileDD extends StatefulWidget {
  EditProfileDD(
      {Key? key,
      required this.button,
      required this.id})
      : super(key: key);
  final id;
  final button;
  XFile? image;
  @override
  _EditProfileDDState createState() => _EditProfileDDState();
}

class _EditProfileDDState extends State<EditProfileDD> {
  bool? isUserAdded;
  bool updateProfile=false;
  final TextEditingController _controllerName =  TextEditingController();
  final TextEditingController _controllerState =  TextEditingController();
  final TextEditingController _controllerCity =  TextEditingController();
  final TextEditingController _controllerDistrict =  TextEditingController();
  final TextEditingController _controllerPinCode =  TextEditingController();
  final TextEditingController _controllerAddress =  TextEditingController();


  File? _image;
  var imagePicker;
  var type;
  var imageData;
  bool uplaodImage = true;

  var fetchImageData;
  var fetchUserData;

  var dataDegree;
  bool dataHomeFlag = true;
  var dataLanguages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    _getImageUrl(widget.id);
    imagePicker = ImagePicker();
  }

  void _getImageUrl(String doctorId) async {
    fetchImageData = await ApiEditProfiles.getImgeUrl(doctorId);
    if (fetchImageData[0]['image'] != '') {
      if (mounted) {
        setState(() {
          uplaodImage = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          uplaodImage = false;
        });
      }
    }
  }

  void _handleURLButtonPress(BuildContext context, var type) async {
    var source = type == ImageSourceType.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    XFile image = await imagePicker.pickImage(
        source: source,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
    if (mounted) {
      setState(() {
        _image = File(image.path);
        uplaodImage=true;
      });
    }
    if (_image != null) {
      Dio.FormData formData = Dio.FormData.fromMap({
        "patient_id": widget.id,
        "image": await Dio.MultipartFile.fromFile(_image!.path,
            filename: _image!.path.split('/').last)
      });
      bool result = await ProfileServices.create(formData);
      if (result == true) {
        if (mounted) {
          setState(() {
            _getImageUrl(widget.id);
          });
        }
      }
    } else {

    }

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  Future<void> getUserData() async {
    var API = '${API_BASE_URL}patient_fetch_profile_api.php';
    Map<String, dynamic> body = {
      'patient_id': widget.id,
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to fetchProfileData: $error"));
    if (response.statusCode == 200) {
      fetchUserData = jsonDecode(response.body.toString());
      if (mounted) {
        setState(() {
          _controllerName.text=fetchUserData[0]['patient_name'];
          _controllerAddress.text=fetchUserData[0]['address'];
          _controllerState.text=fetchUserData[0]['state'];
          stateInitial=fetchUserData[0]['state'];
          _controllerCity.text=fetchUserData[0]['city'];
          _controllerDistrict.text=fetchUserData[0]['district'];
          _controllerPinCode.text=fetchUserData[0]['pincode'];
        });
      }
    } else {
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEditted = false;
  var stateInitial="Andhra Pradesh";
  var stateList = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry"
  ];

  stateWidget(){
    return  Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Theme(
        data:  ThemeData(
          primaryColor: Colors.redAccent,
          primaryColorDark: Colors.red,
        ),
        child: Container(
          margin: const EdgeInsets.all(1.0),
          padding: const EdgeInsets.only(left: 5.0),
          decoration: myBoxDecoration(),
          height: 60,
          //
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButton(
              // Initial Value
                menuMaxHeight: MediaQuery.of(context).size.height,
                value: stateInitial,
                dropdownColor: Colors.white,
                focusColor: Colors.blue,
                isExpanded: true,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: stateList.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (user) {
                  if (mounted) {
                    setState(() {
                      stateInitial = user.toString();
                    });
                  }
                }),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    side: BorderSide(color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: kSpacingUnit.w * 10,
                            width: kSpacingUnit.w * 10,
                            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    uplaodImage?null:showAlertDialog(context);
                                  },
                                  child: uplaodImage
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : fetchImageData[0]['image'] != null
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
                                    decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      heightFactor: kSpacingUnit.w * 1.5,
                                      widthFactor: kSpacingUnit.w * 1.5,
                                      child: Icon(
                                        LineAwesomeIcons.camera,
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
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        CustomFormField(
                            controlller: _controllerName,
                            errorMsg: 'Enter Your Name',
                            labelText: 'Patient Name',
                            readOnly: false,
                            icon: Icons.person,
                            maxLimit: 25,
                            maxLimitError: '25',
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerAddress,
                            errorMsg: 'Enter Your Address',
                            labelText: 'Address',
                            readOnly: false,
                            icon: Icons.home,
                            maxLimit: 40,
                            maxLimitError: '40',
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        stateWidget(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerCity,
                            errorMsg: 'Enter Your City',
                            labelText: 'City',
                            readOnly: false,
                            icon: Icons.location_city,
                            maxLimit: 25,
                            maxLimitError: '25',
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerDistrict,
                            errorMsg: 'Enter Your District',
                            readOnly: false,
                            labelText: 'District',
                            maxLimit: 25,
                            maxLimitError: '25',
                            icon: Icons.location_city_sharp,
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerPinCode,
                            errorMsg: 'Enter Your Pin',
                            readOnly: false,
                            labelText: 'Pin',
                            maxLimit: 6,
                            maxLimitError: '6',
                            icon: Icons.pin,
                            textInputType: TextInputType.number),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        const Divider(
                          color: Colors.black12,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .87,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  _updateProfile(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    textStyle: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                child: updateProfile?const Center(child: CircularProgressIndicator(color: Colors.white,),):Text(
                                  widget.button,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              _handleURLButtonPress(context, ImageSourceType.gallery);
            },
            child: const ListTile(
                title: Text("From Gallery"),
                leading: Icon(
                  Icons.image,
                  color: Colors.deepPurple,
                )),
          ),
          Container(
            width: 200,
            height: 1,
            color: Colors.black12,
          ),
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              _handleURLButtonPress(context, ImageSourceType.camera);
            },
            child: const ListTile(
                title: Text(
                  "From Camera",
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(
                  Icons.camera,
                  color: Colors.red,
                )),
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<String> addProfile(ModelProfile? model) async {
    print('${model?.address}');
    var APIURL = '${API_BASE_URL}update_patient_profile_api.php';
    http.Response response = await http
        .post(Uri.parse(APIURL), body: model?.toJson())
        .then((value) => value)
        .catchError((error) => print("doctore Failed to addProfile: $error"));
    var data = jsonDecode(response.body);
    print("addProfile DATA: $data");
    return data[0]['patient_name'];
  }

  _updateProfile(BuildContext context) async {
    if (mounted) {
      setState(() {
        updateProfile=true;
      });
    }
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() {
          isEditted = true;
        });
      }
      String assistantName = await addProfile(ModelProfile(
        patient_id: widget.id,
        patient_name: _controllerName.text.toString(),
        address: _controllerAddress.text.toString(),
        state: stateInitial,
        city: _controllerCity.text.toString(),
        district: _controllerDistrict.text.toString(),
        pincode: _controllerPinCode.text.toString(),
      ));
      if (assistantName == _controllerName.text) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('userName', _controllerName.text);
        if (mounted) {
          setState(() {
            updateProfile=false;
          });
        }
        CustomSnackBar.snackBar(
            context: context,
            data: 'updated Successfully !',
            color: Colors.green);
        if (mounted) {
          setState(() {
            isEditted = false;
          });
        }
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        updateProfile=false;
        CustomSnackBar.snackBar(
            context: context,
            data: 'Failed to update !',
            color: Colors.red);
      }
    }
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black26),
      borderRadius: const BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }
}
