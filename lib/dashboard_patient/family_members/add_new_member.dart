import 'dart:convert';

import 'package:medilife_patient/core/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:medilife_patient/core/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ModelRelation {
  ModelRelation({
    this.relation,
  });

  String? relation;

  factory ModelRelation.fromJson(Map<String, dynamic> json) => ModelRelation(
        relation: json["relation"],
      );
}

class AddMemberPD extends StatefulWidget {
  const AddMemberPD({Key? key, required this.patientID}) : super(key: key);
  final patientID;

  @override
  _AddMemberPDState createState() => _AddMemberPDState();
}

class _AddMemberPDState extends State<AddMemberPD> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  String? name = ' ';
  String? number;

  String? pills = '';
  List<String> pillsList = [];
  bool relationFlag = true;
  bool addMembers = false;

  var dataAddDoses;
  bool dataAddDosesF = false;

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    name = preferences.getString('name');
    number = preferences.getString('number');
    name = 'saboor';
    number = '9090909098';
    if (mounted) {
      setState(() {
      });
    }
  }

  Future<void> getAllRelation() async {
    print('.getAllRelation ..............................');
    var API =
        'https://cabeloclinic.com/website/medlife/php_auth_api/relation_api.php';
    http.Response response = await http
        .post(Uri.parse(API))
        .then((value) => value)
        .catchError((error) => print(" Failed to getAllPills $error"));
    // print('...............................${response.body}');
    if (response.statusCode == 200) {
      print('..getAllRelation....${response.body}');
      Iterable l = jsonDecode(response.body.toString());
      List<ModelRelation> pillss = List<ModelRelation>.from(
          l.map((model) => ModelRelation.fromJson(model)));
      for (int i = 0; i < pillss.length; i++) {
        // print('////////////////////${pillss[i].relation}');
      }
      for (int i = 0; i < pillss.length; i++) {
        // print('////////////////////${pillss[i].relation}');
        pillsList.add('${pillss[i].relation}');
      }
      setState(() {
        relationFlag = false;
        pills = pillss[0].relation;
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    getAllRelation();
  }

  String? relative = 'Grand Father';
  var genderList = ['Male', 'Female', 'Others'];
  String? gender = 'Male';
  var relatives = [
    "Grand Father",
    "Grand Mother",
    "Father",
    "Mother",
    "Doughter",
    "Son",
    "Brother",
    "Sister",
    "Uncle",
    "Aunty"
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Add New Member'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24, // Changing Drawer Icon Size
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * .95,
                    height: MediaQuery.of(context).size.height * .6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(8, 8, 0, 15),
                        //   child: TitleText(text: ' Profile Details'),
                        // ),

                        SizedBox(
                          height: 15,
                        ),
                        CustomFormField(
                            readOnly: false,
                            controlller: _controllerName,
                            errorMsg: 'Enter Your Name',
                            labelText: 'Name',
                            icon: Icons.perm_identity,
                            textInputType: TextInputType.text),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
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
                                    menuMaxHeight:
                                        MediaQuery.of(context).size.height,
                                    value: pills,
                                    dropdownColor: Colors.white,
                                    focusColor: Colors.blue,
                                    isExpanded: true,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    // Array list of items
                                    items: pillsList.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (spec) {
                                      if (mounted) {
                                        setState(() {
                                          relative = spec.toString();
                                          pills = relative;
                                        });
                                      }
                                      print('------------------${spec}');
                                    }),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
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
                                    menuMaxHeight:
                                        MediaQuery.of(context).size.height,
                                    value: gender,
                                    dropdownColor: Colors.white,
                                    focusColor: Colors.blue,
                                    isExpanded: true,
                                    // Down Arrow Icon
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    // Array list of items
                                    items: genderList.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (spec) {
                                      if (mounted) {
                                        setState(() {
                                          gender = spec.toString();
                                        });
                                      }
                                      print('------------------${spec}');
                                    }),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20),
                          child: Theme(
                            data: new ThemeData(
                              primaryColor: Colors.redAccent,
                              primaryColorDark: Colors.red,
                            ),
                            child: new TextFormField(
                              textInputAction: TextInputAction.next,
                              maxLength: 2,
                              readOnly: false,
                              controller: _controllerAge,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Age';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.teal)),
                                  labelText: 'Age',
                                  prefixText: ' ',
                                  prefixIcon: Icon(
                                    Icons.numbers,
                                    color: Colors.blue,
                                  ),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .87,
                            height: 60,
                            child: Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  addMember(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.pink,
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                child: addMembers
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Add Memeber",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   decoration:
              //   BoxDecoration(border: Border.all(color: Colors.blueAccent),color: Colors.white),
              //   child: Center(child: Text('कम से कम १०० रुपए डाल सकते हैं। ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.redAccent),)),
              // ),
            ],
          ),
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

  addMember(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      addMem();
    }
  }

  void addMem() async {
    if (mounted) {
      setState(() {
        addMembers = true;
        dataAddDosesF = true;
      });
    }
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/member_add_api.php';
    Map<String, dynamic> body = {
      'parent_id': widget.patientID,
      'name': _controllerName.text,
      'relation': pills,
      'age': _controllerAge.text,
      'gender': gender,
    };
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to addDoses: $error"));
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          dataAddDosesF = false;
        });
      }
      // print('..addDoses 22222222222222222222222222222222....${response.body}');
      dataAddDoses = jsonDecode(response.body.toString());
      if (dataAddDoses[0]['status'] == '1') {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Added Successfully !',
            color: Colors.green);
        if (mounted) {
          setState(() {

          });
        }
        Navigator.pop(context);
      } else {
        if (mounted) {
          setState(() {
            addMembers = false;
          });
        }
        CustomSnackBar.snackBar(
            context: context,
            data: 'Failed to Registration !',
            color: Colors.red);
      }
    } else {}
  }
}
