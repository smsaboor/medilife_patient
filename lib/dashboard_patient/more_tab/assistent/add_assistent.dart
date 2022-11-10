import 'dart:convert';
import 'package:medilife_patient/core/constants.dart';
import 'package:flutter_package1/CustomFormField.dart';
import 'package:flutter_package1/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/custom_widgtes/app_bar.dart';
import 'package:medilife_patient/model/model_assistence.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class AddAssistent extends StatefulWidget {
  const AddAssistent({Key? key, required this.button, required this.doctor_id})
      : super(key: key);
  final button;
  final doctor_id;

  @override
  _AddAssistentState createState() => _AddAssistentState();
}

class _AddAssistentState extends State<AddAssistent> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _controllerName =  TextEditingController();
  final TextEditingController _controllerMobile =  TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  bool isAssistentAdded = false;
  String? symptoms = 'Morning Empty Stomach';
  var symptomsList = [
    "Morning Empty Stomach",
    "Morning After Breakfast",
    "Before Launch",
    "After Launch",
    "Evening",
    "Before Dinner",
    "After Dinner",
    "Before Sleep",
  ];

  String? status = 'Active';
  var statusList = [
    "Active",
    "Left",
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          isleading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: Colors.blue,
              title: const Text("Add Assistant"),
            ),
            SizedBox(
              height: 450,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 10,
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormField(
                            controlller: _controllerName,
                            errorMsg: 'Enter Assistant Name',
                            labelText: 'Assistant Name',
                            readOnly: false,
                            icon: Icons.person,
                            maxLimit: 25,
                            maxLimitError: '25',
                            textInputType: TextInputType.text),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        CustomFormField(
                            controlller: _controllerMobile,
                            errorMsg: 'Enter Your Mobile',
                            labelText: 'Mobile',
                            readOnly: false,
                            icon: Icons.phone_android,
                            maxLimit: 10,
                            maxLimitError: '10',
                            textInputType: TextInputType.number),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Theme(
                          data:  ThemeData(
                            primaryColor: Colors.redAccent,
                            primaryColorDark: Colors.red,
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 18.0, right: 18.0, bottom: 15),
                            padding: const EdgeInsets.only(left: 10.0),
                            decoration: myBoxDecoration(),
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButton(
                                // Initial Value
                                menuMaxHeight:
                                    MediaQuery.of(context).size.height,
                                value: status,
                                dropdownColor: Colors.white,
                                focusColor: Colors.blue,
                                isExpanded: true,
                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),
                                // Array list of items
                                items: statusList.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (spec) {
                                  if (mounted) {
                                    setState(() {
                                      status = spec.toString();
                                    });
                                  }
                                }),
                          ),
                        ),
                        CustomFormField(
                            controlller: _controllerAddress,
                            errorMsg: 'Enter Full Address',
                            labelText: 'Address',
                            readOnly: false,
                            icon: Icons.person,
                            maxLimit: 40,
                            maxLimitError: '40',
                            textInputType: TextInputType.text),
                        const Divider(
                          color: Colors.black12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .87,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                _add(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  textStyle: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                              child: isAssistentAdded
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Text(
                                      widget.button,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<String> addAssistent(ModelAssistent? model) async {
    print('${model?.assistantName}');
    var APIURL =API_BASE_URL+API_DD_ASSISTENT_ADD;
    http.Response response = await http
        .post(Uri.parse(APIURL), body: model?.toJson())
        .then((value) => value)
        .catchError(
            (error) => print("doctore assistenet Failed to add: $error"));
    var data = jsonDecode(response.body);
    print("getRegistration DATA: $data");
    return data[0]['assistant_name'];
  }

  _add(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isAssistentAdded = true;
      });
      String assistantName = await addAssistent(ModelAssistent(
        assistantName: _controllerName.text.toString(),
        number: _controllerMobile.text.toString(),
        address: _controllerAddress.text.toString(),
        doctorId: widget.doctor_id,
        status: status,
      ));
      if (assistantName == _controllerName.text) {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Added Successfully !',
            color: Colors.green);
        setState(() {
          isAssistentAdded = false;
        });
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        CustomSnackBar.snackBar(
            context: context,
            data: 'Failed to Registration !',
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
