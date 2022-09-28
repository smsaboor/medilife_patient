import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:medilife_patient/core/custom_snackbar.dart';
import 'package:medilife_patient/dashboard_patient/home_patient_dashboard.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentMode extends StatefulWidget {
  const PaymentMode({Key? key,
    required this.memberId,
    required this.doctorId,
    required this.patientId,
    required this.id,
    required this.fees,
    required this.bookingType,
    required this.name})
      : super(key: key);
  final memberId;
  final doctorId;
  final patientId;
  final id, fees, name, bookingType;
  @override
  State<PaymentMode> createState() => _PaymentModeState();
}

class _PaymentModeState extends State<PaymentMode> {
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;
  String? OrderId;
  var dataAddAppointment;
  int? amount;
  var dataOredr;
  bool dataAddDosesF=false;
  Future<String> generateOrderId(int amount) async {
    print('generateOrderId called');
    print('object-----------------------$amount');
    print('object-----------------------${amount.runtimeType}');
    var authn = 'Basic ' +
        base64Encode(utf8.encode('$API_RAZORPAY_KEY:$API_RAZORPAY_SECRETKEY'));
    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };
    var data =
        '{ "amount": ${amount},"currency": "INR", "receipt": "${widget
        .id}", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!
    var res = await http.post(Uri.parse(API_RAZORPAY_GENERATE_ID),
        headers: headers, body: data);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res}');
    print('ORDER ID response => ${res.body}');
    OrderId = json.decode(res.body)['id'].toString();
    // generateOrders(key,secret,json.decode(res.body)['id'].toString());
    return json.decode(res.body)['id'].toString();
  }

  Future<String> searchOrder(String orderId) async {
    print('generateOrders called');
    var authn = 'Basic ' +
        base64Encode(utf8.encode('$API_RAZORPAY_KEY:$API_RAZORPAY_SECRETKEY'));
    var headers = {
      'content-type': 'application/json',
      'Authorization': authn,
    };
    String ID = orderId;
    var data = '{"order_id": $orderId}'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!
    var res = await http.get(Uri.parse(API_RAZORPAY_GET_ORDER_DETAIL + ID),
        headers: headers);
    if (res.statusCode != 200)
      throw Exception('http.post error: statusCode= ${res}');
    print('generateOrders => ${res.body}');
    OrderId = json.decode(res.body)['id'].toString();
    dataOredr = json.decode(res.body);
    return json.decode(res.body)['id'].toString();
  }

  @override
  void initState() {
    super.initState();
    amount = int.parse('${widget.fees}');
    print('PaymentMode---------------------${widget.id} ${widget.fees}');
    _razorpay = Razorpay();
    // generateOrderId('rzp_test_tGshPQrADIRXhp','TIhrEDLyPnCkAv1CS6tpJoOD',1);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    payment();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_5rUUxqQ4TfrgaX',
      'amount': amount,
      'order_id': OrderId,
      "currency": "INR",
      "accept_partial": true,
      "notify": {"sms": true, "email": true},
      "reminder_enable": true,
      'name': widget.name.toString(),
      'description': widget.id.toString(),
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '9455106497', 'email': 'mca.saboor@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      print('openCheckout1---------------------${options}');
      _razorpay.open(options);
      print('openCheckout2---------------------${options}');
    } catch (e) {
      debugPrint('openCheckouterror: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Success Response: $response');
    print('Success orderId: ${response.orderId}');
    debugPrint('Success paymentId: ${response.paymentId}');
    debugPrint('Success signature: ${response.signature}');
    debugPrint('Success runtimeType: ${response.runtimeType}');
    debugPrint('Success toString: ${response.toString()}');
    await searchOrder(response.orderId!);
    addPayment();
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId!,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    print('Error Response: ${response.code}');
    print('Error Response: ${response.message}');
    Fluttertoast.showToast(
        msg: "OOPS ! " + 'Payment Process is Cancelled.');
    Navigator.pop(context);
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => PatientDashboard(),
    //   ),
    //       (route) => false,
    // );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  coollert(String? payId) {
    return CoolAlert.show(
        title: '',
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(
                  'Booking Sheduled !',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                )),
            SizedBox(
              height: 8,
            ),
            Center(
              child: Row(
                children: [
                  Text(
                    'Transaction Id : ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    payId ?? '',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Center(
              child: Row(
                children: [
                  Text(
                    'Appointment No : ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    widget.id,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3,
            ),
            SizedBox(
              height: 3,
            ),
            Center(
              child: Row(
                children: [
                  Text(
                    'Our Estimate Time: ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.pink),
                  ),
                  Text(
                    '2:30 Mins',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        context: context,
        type: CoolAlertType.success,
        autoCloseDuration: Duration(seconds: 600),
        onConfirmBtnTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => PatientDashboard(),
            ),
                (route) => false,
          );
        });
  }

  payment() async {
    await generateOrderId(int.parse(widget.fees));
    openCheckout();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(color: Colors.red,)),
            SizedBox(height: 10,),
            Center(child: Column(
              children: [
                Text('         Please wait ...'),
                SizedBox(height: 5,),
                Text('You are redirect to Payment Gateway!'),
              ],
            ),)
          ],
        ),
      ),
    ),);
  }


  void addPayment() async {
    print('..addAppointment called');
    if (mounted) {
      setState(() {
        dataAddDosesF = true;
      });
    }
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/razorpay_transaction_api.php';

    Map<String, dynamic> body = {
      'patient_id': widget.patientId.toString(),
      'doctor_id': widget.doctorId['id'].toString(),
      'type': widget.bookingType.toString(),
      'member_id': widget.memberId.toString(),
      'appointment_no': widget.id.toString(),
      'order_id': OrderId.toString(),
      'amount': dataOredr['amount'].toString(),
      'amount_paid': dataOredr['amount_paid'].toString(),
      'amount_due': dataOredr['amount_due'].toString(),
      'receipt_no': dataOredr['receipt'].toString(),
      'status': dataOredr['status'].toString(),
      'notes': dataOredr['notes'].toString(),
      'created_at': dataOredr['created_at'].toString(),
    };
    print('-----------------333333333333333333333${body}');
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to addDoses: $error"));
    if (response.statusCode == 200) {
      print('..responseaddAppointment 22222222222222222222222222222222');
      if (mounted) {
        setState(() {
          // dataAddDosesF = false;
        });
      }
      print('..addAppointment 22222222222222222222222222222222....${response
          .body}');
      print('..addAppointment 22222222222222222222222222222222....${response
          .body}');
      dataAddAppointment = jsonDecode(response.body.toString());
      if (dataAddAppointment[0]['status'] == '1') {
        if (mounted) {
          setState(() {});
        }
        coollert(OrderId);
      } else {
        Fluttertoast.showToast(
            msg: "OOPS ! " + 'Payment Process is Cancelled.');
        Navigator.pop(context);
      }
    } else {}
  }
}
