import 'dart:convert';
import 'package:medilife_patient/core/custom_form_field.dart';
import 'package:medilife_patient/core/custom_snackbar.dart';
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
  final TextEditingController _startDateController =
      new TextEditingController();
  final TextEditingController _controllerName = new TextEditingController();
  // final TextEditingController _controllerMobile = new TextEditingController();
  final TextEditingController _controllerState = new TextEditingController();
  final TextEditingController _controllerCity = new TextEditingController();
  final TextEditingController _controllerDistrict = new TextEditingController();
  final TextEditingController _controllerPincode = new TextEditingController();
  final TextEditingController _controllerAddress = new TextEditingController();


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
    print('####---------------${widget.id} ------------${widget.button}  ');
    getUserData();
    _getImgeUrl(widget.id);
    imagePicker = new ImagePicker();
  }

  void _getImgeUrl(String doctorId) async {
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
      Dio.FormData formData = new Dio.FormData.fromMap({
        "patient_id": widget.id,
        "image": await Dio.MultipartFile.fromFile(_image!.path,
            filename: _image!.path.split('/').last)
      });
      bool result = await ProfileServices.create(formData);
      if (result == true) {
        if (mounted) {
          setState(() {
            _getImgeUrl(widget.id);
          });
        }
      }
    } else {

    }

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  Future<void> getUserData() async {
    print('111*****************${widget.id}');
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/patient_fetch_profile_api.php';
    Map<String, dynamic> body = {
      'patient_id': widget.id,
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to fetchProfileData: $error"));
    print('*****************${widget.id}');
    if (response.statusCode == 200) {
      fetchUserData = jsonDecode(response.body.toString());
      print('*****************${fetchUserData}');
      if (mounted) {
        setState(() {
          _controllerName.text=fetchUserData[0]['patient_name'];
          _controllerAddress.text=fetchUserData[0]['address'];
          _controllerState.text=fetchUserData[0]['state'];
          stateInitial=fetchUserData[0]['state'];
          _controllerCity.text=fetchUserData[0]['city'];
          _controllerDistrict.text=fetchUserData[0]['district'];
          _controllerPincode.text=fetchUserData[0]['pincode'];
        });
      }
    } else {
      print('***else**************${widget.id}');
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        data: new ThemeData(
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
          //          <// --- BoxDecoration here
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
                // After selecting the desired option,it will
                // change button value to selected value
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
        title: Text("Edit Profile"),
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
                  shape: RoundedRectangleBorder(
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
                                      ? Center(
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
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
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
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        // CustomFormField(
                        //     controlller: _controllerMobile,
                        //     errorMsg: 'Enter Your Mobile',
                        //     labelText: 'Mobile',
                        //     readOnly: true,
                        //     icon: Icons.phone_android,
                        //     textInputType: TextInputType.number),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerAddress,
                            errorMsg: 'Enter Your Address',
                            labelText: 'Address',
                            readOnly: false,
                            icon: Icons.home,
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
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerDistrict,
                            errorMsg: 'Enter Your District',
                            readOnly: false,
                            labelText: 'District',
                            icon: Icons.location_city_sharp,
                            textInputType: TextInputType.text),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerPincode,
                            errorMsg: 'Enter Your Pin',
                            readOnly: false,
                            labelText: 'Pin',
                            icon: Icons.pin,
                            textInputType: TextInputType.number),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Divider(
                          color: Colors.black12,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .87,
                              height: 50,
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MyHomePage()));
                                    _updateProfile(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold)),
                                  child: updateProfile?Center(child: CircularProgressIndicator(),):Text(
                                    widget.button,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
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
    // Create button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () async {
              Navigator.pop(context);
              _handleURLButtonPress(context, ImageSourceType.gallery);
            },
            child: Container(
              child: ListTile(
                  title: Text("From Gallery"),
                  leading: Icon(
                    Icons.image,
                    color: Colors.deepPurple,
                  )),
            ),
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
            child: Container(
              child: ListTile(
                  title: Text(
                    "From Camera",
                    style: TextStyle(color: Colors.red),
                  ),
                  leading: Icon(
                    Icons.camera,
                    color: Colors.red,
                  )),
            ),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<String> addProfile(ModelProfile? model) async {
    print('${model?.address}');
    var APIURL = 'https://cabeloclinic.com/website/medlife/php_auth_api/update_patient_profile_api.php';
    http.Response response = await http
        .post(Uri.parse(APIURL), body: model?.toJson())
        .then((value) => value)
        .catchError((error) => print("doctore Failed to addProfile: $error"));
    var data = jsonDecode(response.body);
    print("addProfile DATA: ${data}");
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
      String assistant_name = await addProfile(ModelProfile(
        patient_id: widget.id,
        patient_name: _controllerName.text.toString(),
        address: _controllerAddress.text.toString(),
        state: stateInitial,
        city: _controllerCity.text.toString(),
        district: _controllerDistrict.text.toString(),
        pincode: _controllerPincode.text.toString(),
      ));
      if (assistant_name == _controllerName.text) {
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
        Navigator.pop(context);
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
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }
}
