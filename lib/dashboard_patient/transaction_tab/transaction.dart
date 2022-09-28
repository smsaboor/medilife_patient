import 'dart:convert';
import 'package:medilife_patient/dashboard_patient/custom_widgtes/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:medilife_patient/dashboard_patient/app_bar.dart';
import 'package:medilife_patient/dashboard_patient/transaction_tab/payment.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransactionTabPD extends StatefulWidget {
  const TransactionTabPD({Key? key, required this.userData, this.doctor_id})
      : super(key: key);
  final userData;
  final doctor_id;
  @override
  _TransactionTabPDState createState() => _TransactionTabPDState();
}

class _TransactionTabPDState extends State<TransactionTabPD> {
  var dataTransaction;
  var dataTransactionDate;
  bool dataF = true;
  bool dataFF = true;
  bool isDate = false;

  String? name = '2022-08-09';
  var data2;
  bool loading = true;

  Future<void> getAllTrans() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    print('.....getAllTrans2......................${widget.doctor_id}....}');
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/all_patient_transaction_api.php';
    Map<String, dynamic> body = {'patient_id': widget.doctor_id};
    print('.....getAllTrans2......................${widget.doctor_id}....}');
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getAllTrans: $error"));
    print('.....getAllTrans2......................${widget.doctor_id}....}');
    print('....getAllTrans2...........................${response.body}');
    if (response.statusCode == 200) {
      dataTransaction = jsonDecode(response.body.toString());
      loading = false;
      if (dataTransaction[0]['status'] == '0') {
        if (mounted) {
          setState(() {
            dataF = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            dataF = false;
          });
        }
      }
    } else {}
  }

  Future<void> getDateTrans(String date) async {
    if (mounted) {
      setState(() {
        loading = true;
        dataF = true;
      });
    }
    print('date: $date');
    var API = 'https://cabeloclinic.com/website/medlife/php_auth_api/datewise_patient_transaction_api.php';
    print('date tra...2.....................${widget.doctor_id}');
    Map<String, dynamic> body = {'patient_id': widget.doctor_id, 'date': date};
    http.Response response = await http
        .post(Uri.parse(API), body: body)
        .then((value) => value)
        .catchError((error) => print(" Failed to getAllAssitents: $error"));
    if (response.statusCode == 200) {
      dataTransaction = jsonDecode(response.body.toString());
      loading = false;
      if (dataTransaction[0]['status'] == '0') {
        if (mounted) {
          setState(() {
            dataF = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            dataF = false;
            isDate = true;
          });
        }
      }
    } else {}
  }

  callApis(){
    getAllTrans();
  }
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    callApis();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    callApis();
    if (mounted) {
      setState(() {});
    }
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTrans();
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      if (mounted) {
        setState(() {
          selectedDate = picked;
          name = formattedDate.toString();
          getDateTrans(name.toString());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBarPD(
          isleading: false,
        ),
      ),
      body:SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: 	WaterDropMaterialHeader(color: Colors.blue),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _refreshController,
          child: getBody()),
    );
  }

  getBody(){
    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.blue,
            automaticallyImplyLeading: false,
            title: Text('All Transactions'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: SizedBox(
                    child: Image.asset('assets/images/cal.jpg'),
                    height: 30,
                    width: 30,
                  ),
                ),
              )
            ],
          ),
          loading ? Center(child: CircularProgressIndicator()): dataTransaction[0]['status'] == '0'?
          GestureDetector(
              onTap: (){
                // Navigator.of(context).push(MaterialPageRoute(builder: (_)=>RazorPay()));
              },
              child: Center(child: Text('No Transcation Found!')))
              : ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: dataTransaction.length,
              itemBuilder: (context, index) {
                return accountItems(
                    "Transaction: ${dataTransaction[index]['transaction_id']}",
                    '${dataTransaction[index]['amount']} Rs',
                    "${dataTransaction[index]['transaction_date']}",
                    '${dataTransaction[index]['transaction_type']}',
                    oddColour: const Color(0xFFF7F7F9));
              })
        ],
      ),
    );
  }
  Container accountItems(String item, String charge, String dateString,
      String type,
      {Color oddColour = Colors.white}) =>
      Container(
        decoration: BoxDecoration(color: oddColour),
        padding:
        EdgeInsets.only(top: 20.0, bottom: 20.0, left: 5.0, right: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(item, style: TextStyle(fontSize: 16.0)),
                Text(charge, style: TextStyle(fontSize: 16.0))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dateString,
                    style: TextStyle(color: Colors.grey, fontSize: 14.0)),
                Text(type, style: TextStyle(color: Colors.grey, fontSize: 14.0))
              ],
            ),
          ],
        ),
      );
}
