import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:medilife_patient/core/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/doctor/payment_mode.dart';
import 'package:medilife_patient/dashboard_patient/theme/colors.dart';
import 'package:medilife_patient/dashboard_patient/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect_formfield/multiselect_formfield.dart';

import 'package:medilife_patient/core/constants.dart';

class ModelMember {
  ModelMember({this.id, this.name, this.relation});

  String? id;
  String? name;
  String? relation;

  factory ModelMember.fromJson(Map<String, dynamic> json) => ModelMember(
        id: json["id"],
        name: json["name"],
        relation: json["relation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "relation": relation,
        "name": name,
      };
}

class SheetLabTest extends StatefulWidget {
  const SheetLabTest(
      {Key? key,
      required this.patientId,
      required this.testName,
      required this.testId,
      required this.fees})
      : super(key: key);
  final patientId;
  final testName;
  final testId;
  final fees;

  @override
  State<SheetLabTest> createState() => _SheetLabTestState();
}

class _SheetLabTestState extends State<SheetLabTest> {
  var members;
  bool membersF = false;

  Future<void> getMembers() async {
    var API = 'member_list_api.php';
    Map<String, dynamic> body = {'patient_id': widget.patientId};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      members = jsonDecode(response.body.toString());
      // print('..getAllMemberss....${response.body}');
      if (mounted) {
        setState(() {
          membersF = false;
        });
      }
    } else {}
  }

  Future<void> getAllMemberss() async {
    var API = 'member_list_api.php';
    Map<String, dynamic> body = {'patient_id': widget.patientId};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      members = jsonDecode(response.body.toString());
      List<ModelMember> pillss = [];
      pillss.add(
        ModelMember(
            id: members[0]['patient_id'],
            name: members[0]['Patient_name'],
            relation: 'self'),
      );
      for (int i = 0; i < members[0]['members'].length; i++) {
        pillss.add(
          ModelMember(
              id: members[0]['members'][i]['member_id'],
              name: members[0]['members'][i]['name'],
              relation: members[0]['members'][i]['relation']),
        );
      }
      if (mounted) {
        setState(() {
          memberList2 = pillss;
          selectedMember2 = pillss[0];
        });
      }
      // for (int i = 0; i < members[0]['members'].length; i++) {
      //   pillss.add(
      //     ModelMember(
      //         name: members[0]['members'][i]['name'],
      //         relation: members[0]['members'][i]['relation']),
      //   );
      // }
      // for (int i = 0; i < pillss.length; i++) {
      //   print('////////////////////${pillss[i].name}---${pillss[i].relation}');
      //   selectedMember = '${pillss[0].name} (${pillss[0].relation})';
      //   memberList.add('${pillss[i].name} (${pillss[i].relation})');
      // }
      if (mounted) {
        setState(() {});
      }
    } else {}
  }

  String? selectedMember = '';
  ModelMember? selectedMember2 = ModelMember();
  List<String> memberList = [];
  List<ModelMember> memberList2 = [];
  bool bookNowF = false;
  bool addLabTestF = false;
  String testName = '';
  var databookTest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getMembers();
    getAllMemberss();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controllerDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.white,
              leading: GestureDetector(
                child: Icon(
                  Icons.cancel,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                '${widget.testName}',
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0,
              centerTitle: true,
            ),
            Center(
              child: Text(
                'Select Date & Patient Name for ${widget.testName}',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.only(left: 5.0),
              //decoration: myBoxDecoration(),
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DateTimeField(
                      controller: _controllerDate,
                      //editable: false,
                      validator: (value) {
                        if (_controllerDate.text.length == 0) {
                          return 'Select Booking Date';
                        }
                        return null;
                      },
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black26, width: 1.0),
                        ),
                        border: const OutlineInputBorder(),
                        labelText: 'Select Booking Date',
                        labelStyle: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      format: DateFormat("dd-MM-yyyy"),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(new Duration(days: 0)),
                          lastDate: DateTime.now().add(new Duration(days: 180)),
                        );
                      },
                      onChanged: (dt) {
                        if (mounted) {
                          setState(() {
                            _controllerDate.text = new DateFormat("yyyy-MM-dd")
                                .format(dt?.add(new Duration(days: 354)) ??
                                DateTime.now());
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Theme(
              data: new ThemeData(
                primaryColor: Colors.redAccent,
                primaryColorDark: Colors.red,
              ),
              child: Container(
                margin:
                    const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 5),
                padding: const EdgeInsets.only(left: 5.0),
                decoration: myBoxDecoration(),
                height: 60,
                width: MediaQuery.of(context).size.width,
                //          <// --- BoxDecoration here
                child: DropdownButton(
                    // Initial Value
                    menuMaxHeight: MediaQuery.of(context).size.height,
                    value: selectedMember2,
                    dropdownColor: Colors.white,
                    focusColor: Colors.blue,
                    isExpanded: true,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: memberList2.map((ModelMember items) {
                      return DropdownMenuItem<ModelMember>(
                        value: items,
                        child: Text(items.name ?? ''),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (spec) {
                      if (mounted) {
                        setState(() {
                          selectedMember2 = spec;
                        });
                      }
                      print('------------------${spec!.name}');
                      print('------------------${spec!.id}');
                    }),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              height: 45,
              child: Container(
                child: ElevatedButton(
                  onPressed: () {
                    addAppointment(context);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  child: bookNowF
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Book Now',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black26),
      borderRadius: BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }

  addAppointment(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      addLabTest();
    }
  }

  void addLabTest() async {
    if (mounted) {
      setState(() {
        addLabTestF = true;
      });
    }
    var API =
        'https://cabeloclinic.com/website/medlife/php_auth_api/add_lab_test_api.php';
    Map<String, dynamic> body = {
      'patient_id': widget.patientId,
      'member_id': widget.patientId == selectedMember2!.id
          ? ''
          : selectedMember2!.id.toString(),
      'lab_test_id': widget.testId,
      'fees': widget.fees,
      'date': _controllerDate.text
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to addDoses: $error"));
    if (response.statusCode == 200) {
      databookTest = jsonDecode(response.body.toString());
      if (databookTest[0]['status'] == '1') {
        CustomSnackBar.snackBar(
            context: context,
            data: 'booking Successfully !',
            color: Colors.green);
        if (mounted) {
          setState(() {
            addLabTestF = false;
          });
        }
        Navigator.pop(context);
      } else {
        CustomSnackBar.snackBar(
            context: context, data: 'Booking Failed !', color: Colors.red);
      }
    } else {}
  }
}
