import 'dart:convert';
import 'package:flutter_package1/custom_snackbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medilife_patient/dashboard_patient/doctor/payment_mode.dart';
import 'package:medilife_patient/dashboard_patient/theme/colors.dart';
import 'package:medilife_patient/dashboard_patient/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:flutter_package1/components.dart';
enum SingingCharacter { Normal, Emergency }

class ModelSymptoms {
  ModelSymptoms({
    this.symptoms_name,
  });

  String? symptoms_name;

  factory ModelSymptoms.fromJson(Map<String, dynamic> json) => ModelSymptoms(
        symptoms_name: json["symptoms_name"],
      );
}

class BookingScreenPD extends StatefulWidget {
  const BookingScreenPD(
      {Key? key,
      this.familyMember,
      this.doctor,
      this.symptoms,
      required this.patientId,
      required this.totalConsult,
      required this.memberType})
      : super(key: key);
  final familyMember;
  final doctor;
  final symptoms;
  final totalConsult;
  final memberType;
  final patientId;

  @override
  _BookingScreenPDState createState() => _BookingScreenPDState();
}

class _BookingScreenPDState extends State<BookingScreenPD> {
  SingingCharacter? _character = SingingCharacter.Normal;
  int index = 0;
  String? pills = '';
  String? pills2 = '';
  List<String> pillsList = [];
  bool relationFlag = true;
  var fees;
  bool feesF = true;
  bool flagSymptoms = true;
  var dataAddAppointment;

  String feesNE = '';
  String feesType = 'NORMAL';
  bool dataAddDosesF = false;
  List<dynamic>? modelSymptoms1 = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerDate =  TextEditingController();
  final TextEditingController _controllerSymptoms =  TextEditingController();

  void _modalMenu(String id, String fees, String name) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .65,
                  child: const Text(
                    'Select Payment Type',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ),
                ),
              ),
              const Divider(thickness: 1),
              ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.deepPurple,
                  ),
                  title: const Text('Full Payment',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  onTap: () {
                    addAppointment('FULLY',double.parse(feesNE));
                    // emergency_fees
                  }),
              const Divider(thickness: .1),
              ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.deepPurple,
                  ),
                  title: const Text('Partial Payment',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  onTap: () {
                    addAppointment('PARTIAL',double.parse(feesNE)/10);
                  }),
            ],
          ),
        );
        // return RazorPay(id: id, patientName: widget.patientId, amount: fees,);
        // return PaymentMode(id: id, fees: fees,name: name,);
      },
    );
  }

  Future<dynamic> getSymptoms() async {
    var API = '${API_BASE_URL}symptoms_api.php';
    try {
      final response = await http.post(Uri.parse(API));
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        List<ModelSymptoms> posts = List<ModelSymptoms>.from(
            l.map((model) => ModelSymptoms.fromJson(model)));
        for (int i = 0; i < posts.length; i++) {
          modelSymptoms1!.add({
            'index': posts[i].symptoms_name.toString(),
            'language': posts[i].symptoms_name.toString()
          });
        }
        for (int i = 0; i < modelSymptoms1!.length; i++) {
          // print('i========${modelSymptoms1![i]}');
        }
        setState(() {
          flagSymptoms = false;
        });
      }
    } catch (e) {
      debugPrint('$e');
      return <ModelSymptoms>[];
    }
  }

  Future<void> getFees() async {
    var API = 'doctor_fees_api.php';
    Map<String, dynamic> body = {'doctor_id': widget.doctor['id']};
    http.Response response = await http
        .post(Uri.parse(API_BASE_URL + API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getLogin: $error"));
    if (response.statusCode == 200) {
      fees = jsonDecode(response.body.toString());
      setState(() {
        feesF = false;
      });
      feesNE = fees[0]['doctor_fee'];
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFees();
    getSymptoms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Booking Schedule",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: getBody(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: MyButtonPD(
            disableButton: false,
            bgColor: primary,
            title: dataAddDosesF ? "Booking..." : "Book Now",
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if(feesType=='EMERGENCY'){
                  DateTime dateToday = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day) ;
                  String date = dateToday.toString().substring(0,10);
                  print('---------${date}--------${_controllerDate.text}------');
                  if(date!=_controllerDate.text){
                    Fluttertoast.showToast(msg: "Sorry ! " + 'For Emergency Select Only Today Date');
                  }else{
                    _modalMenu('1', 'fees', 'name');
                  }
                }else{
                  _modalMenu('1', 'fees', 'name');
                }
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  getBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .15,
                      height: MediaQuery.of(context).size.width * .15,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xff125ace),
                        child: Text(
                          widget.familyMember['status'] == '1'
                              ? widget.familyMember['Patient_name']
                                  .toString()[0]
                                  .toUpperCase()
                              : widget.familyMember['name']
                                  .toString()[0]
                                  .toUpperCase(),
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * .10,
                              color: Colors.white),
                        ), //Text
                      ), //circleAvatar,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.familyMember['status'] == '1'
                                ? (widget.familyMember["Patient_name"].length > 20
                                ? widget.familyMember["Patient_name"]
                                .substring(0, 20) +
                                '...'
                                : widget.familyMember["Patient_name"] ?? '')
                                : (widget.familyMember["name"].length > 20
                                ? widget.familyMember["name"]
                                .substring(0, 20) +
                                '...'
                                : widget.familyMember["name"] ?? ''),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            widget.familyMember['status'] == '1'
                                ? 'self'
                                : (widget.familyMember["relation"].length > 30
                                ? widget.familyMember["relation"]
                                .substring(0, 30) +
                                '...'
                                : widget.familyMember["relation"] ?? ''),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.pink)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Age: ${widget.familyMember['age'].toString()}",
                          style: const TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              "Gender: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.familyMember['gender'].toString().length > 30
                                  ? '${widget.familyMember['gender'].toString()
                                  .substring(0, 30)}...'
                                  : widget.familyMember['gender'].toString() ?? '',
                              style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ContactBox(icon: Icons.videocam_rounded, color: Colors.blue,),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .9,
                        height: 600,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:
                                  const Offset(1, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 1),
                          child: Column(
                            children: [
                              Text("Dr. ${widget.doctor['doctor_name'].toString().length > 25?
                              widget.doctor['doctor_name'].substring(0, 25) +
                                  '...' : widget.doctor["doctor_name"] ?? ''}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.local_hospital,
                                    color: Colors.blue,
                                    size: 26,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text("${widget.doctor['clinic_name'].toString().length > 25?
                                  widget.doctor['clinic_name'].substring(0, 25) +
                                      '...' : widget.doctor["clinic_name"] ?? ''}",
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: RadioListTile<SingingCharacter>(
                                      title: const Text('Normal'),
                                      value: SingingCharacter.Normal,
                                      groupValue: _character,
                                      onChanged: (SingingCharacter? value) {
                                        if (mounted) {
                                          setState(() {
                                            _character = value;
                                            feesNE = fees[0]['doctor_fee'];
                                            feesType = 'NORMAL';
                                            index = 0;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: RadioListTile<SingingCharacter>(
                                      title: const Text('Emergency'),
                                      value: SingingCharacter.Emergency,
                                      groupValue: _character,
                                      onChanged: (SingingCharacter? value) {
                                        if (mounted) {
                                          setState(() {
                                            _character = value;
                                            feesNE = fees[0]['emergency_fees'];
                                            feesType = 'EMERGENCY';
                                            index = 1;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                padding: const EdgeInsets.only(left: 5.0),
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: DateTimeField(
                                        controller: _controllerDate,
                                        //editable: false,
                                        validator: (value) {
                                          if (_controllerDate.text.isEmpty) {
                                            return 'Enter Booking Date';
                                          }
                                          return null;
                                        },
                                        decoration:  const InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 1.0),
                                          ),
                                          enabledBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black26,
                                                width: 1.0),
                                          ),
                                          border: OutlineInputBorder(),
                                          labelText: 'Booking Date',
                                          labelStyle: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        format: DateFormat("yyyy-MM-dd"),
                                        onShowPicker: (context, currentValue) {
                                          return showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                                 const Duration(days: 0)),
                                            lastDate: DateTime.now()
                                                .add( const Duration(days: 240)),
                                          );
                                        },
                                        onChanged: (dt) {
                                          // _endDateController.text =
                                          //     new DateFormat("yyyy-MM-dd").format(dt?.add(new Duration(days: 354)) ?? DateTime.now());
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              flagSymptoms
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container(
                                      padding:
                                          const EdgeInsets.only(left: 18, right: 18),
                                      child: MultiSelectFormField(
                                        border: const OutlineInputBorder(),
                                        autovalidate: AutovalidateMode.disabled,
                                        chipBackGroundColor: Colors.blue,
                                        chipLabelStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        dialogTextStyle: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        checkBoxActiveColor: Colors.blue,
                                        checkBoxCheckColor: Colors.white,
                                        dialogShapeBorder:
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0))),
                                        title: const Text(
                                          "Select Symptoms",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.length == 0) {
                                            return 'Please select one or more options';
                                          }
                                          return null;
                                        },
                                        dataSource: modelSymptoms1,
                                        textField: 'language',
                                        valueField: 'index',
                                        okButtonLabel: 'OK',
                                        cancelButtonLabel: 'CANCEL',
                                        hintWidget:
                                            const Text('Please select Symptoms'),
                                        initialValue: [],
                                        onSaved: (value) {
                                          if (value == null) return;
                                          if (mounted) {
                                            setState(() {
                                              _controllerSymptoms.text =
                                                  value.toString();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(top: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text('Appointment Fees',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text('Rs: $feesNE',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.pink,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0.0, top: 25),
                                child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(10)),
                                    child: Container(
                                      width: 250,
                                      height: 40,
                                      color: Colors.orange,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Estimate Time: ${int.parse(widget.totalConsult) * 15} Minutes',
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black26),
      borderRadius: const BorderRadius.all(
          Radius.circular(5.0) //                 <--- border radius here
          ),
    );
  }

  void addAppointment(String pymentType,double fees) async {
    if (mounted) {
      setState(() {
        dataAddDosesF = true;
      });
    }
    Navigator.pop(context);
    var API = '${API_BASE_URL}normal_booking_api.php';
    Map<String, dynamic> body = {
      'patient_id': widget.patientId,
      'doctor_id': widget.doctor['id'],
      'type': feesType,
      'member_id': widget.memberType == 2
          ? widget.familyMember['member_id'].toString()
          : '',
      'symptoms_name': _controllerSymptoms.text,
      'fees': feesNE,
      'booking_date': _controllerDate.text,
      'payment_type': pymentType
    };
    print('*****************************${body}');
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(error));
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          dataAddDosesF = false;
        });
      }
      dataAddAppointment = jsonDecode(response.body.toString());
      print('22*****************************${dataAddAppointment}');
      if (dataAddAppointment[0]['status'] == '1') {
        print('33*****************************${widget.patientId}');
        print('333*****************************${widget.doctor}');
        print('3333*****************************${widget.memberType == 2
            ? widget.familyMember['member_id'].toString()
            : ''}');
        print('33334*****************************${feesType}');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PaymentMode(
                  fees: fees.toInt().toString(),
                  id: dataAddAppointment[0]['appointment_no'],
                  name: widget.familyMember['status'] == '1'
                      ? widget.familyMember['Patient_name'].toString()
                      : widget.familyMember['name'].toString(),
              patientId: widget.patientId,
              doctorId: widget.doctor,
              memberId: widget.memberType == 2
                  ? widget.familyMember['member_id'].toString()
                  : '',
              bookingType: feesType,
                )));
      } else {
        CustomSnackBar.snackBar(
            context: context, data: 'Sorry Try Again !', color: Colors.red);
      }
    } else {}
  }
}
