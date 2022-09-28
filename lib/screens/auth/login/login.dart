import 'package:medilife_patient/core/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/home_patient_dashboard.dart';
import 'package:medilife_patient/screens/auth/verify_otp.dart';
import 'package:medilife_patient/service/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // getSP()async{
  //   await SharedPreferences.getInstance();
  // }
  late FocusNode text1, text2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text1 = FocusNode();
    text2 = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    text1.dispose();
    text2.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController _controllerMobile = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool tryRegistration = false;
  bool isRegistered = false;
  int? status = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * .15,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Center(child: Image.asset('assets/logo2.png'))),
              SizedBox(
                height: MediaQuery.of(context).size.height * .13,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, bottom: 15),
                child: Text(
                  "SignIn / SignUp Patient",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xE1100A44),
                      fontSize: 26),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Theme(
                  data: ThemeData(
                    primaryColor: Colors.redAccent,
                    primaryColorDark: Colors.red,
                  ),
                  child: new TextFormField(
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    focusNode: text1,
                    controller: _controllerMobile,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Mobile';
                      }
                      return null;
                    },
                    onChanged: (v) {
                      setState(() {
                        tryRegistration = false;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        labelText: 'Mobile',
                        prefixText: ' ',
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: Colors.blue,
                        ),
                        suffixStyle: const TextStyle(color: Colors.green)),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.01),
              isRegistered
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.redAccent,
                          primaryColorDark: Colors.red,
                        ),
                        child: new TextFormField(
                          focusNode: text2,
                          textInputAction: TextInputAction.next,
                          controller: _controllerPassword,
                          onChanged: (v) {
                            if (mounted) {
                              setState(() {
                                tryRegistration = false;
                              });
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Your Password';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              labelText: 'Password',
                              prefixText: ' ',
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Colors.blue,
                              ),
                              suffixStyle:
                                  const TextStyle(color: Colors.green)),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                height: 60,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      _verifyUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.bold)),
                    child: tryRegistration
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isRegistered ? "Login" : "Continue",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _verifyUser(BuildContext context) async {
    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => DoctorDashBoard()));
    if (status == 0) {
      if (formKey.currentState!.validate()) {
        if (mounted) {
          setState(() {
            tryRegistration = true;
          });
        }
        var data = await ApiService.checkUserRegistered(_controllerMobile.text);
        setState(() {
          tryRegistration = false;
        });
        print('status check reg------------${data['status']}');
        if (data['status'] == 1) {
          setState(() {
            isRegistered = true;
            status = 1;
            FocusScope.of(context).requestFocus(text2);
          });
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => OtpVerification(
                    otp: data['otp'],
                    mobile: _controllerMobile.text,
                  )));
        }
      }
    } else {
      if (formKey.currentState!.validate()) {
        if (mounted) {
          setState(() {
            tryRegistration = true;
          });
        }
        var data = await ApiService.login(
            mobile: _controllerMobile.text, pwd: _controllerPassword.text);
        if (data['status'] == '1') {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool('isLogin', true);
          if (data['user_type'] == '1') {
            preferences.setString('userType', data['user_type']);
            preferences.setString('userDetails', data.toString());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PatientDashboard(),
              ),
                  (route) => false,
            );
          } else {
            preferences.setString('userDetails', data.toString());
            preferences.setString('userType', data['user_type']);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => PatientDashboard(),
              ),
                  (route) => false,
            );
          }
          if (mounted) {
            setState(() {
              tryRegistration = false;
            });
          }
        } else {
          CustomSnackBar.snackBar(
              context: context, data: 'Failed to Login !', color: Colors.red);
          if (mounted) {
            setState(() {
              tryRegistration = false;
            });
          }
        }
      }
    }
  }

  bool _isEmailValidate(String txt) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(txt);
  }
}
