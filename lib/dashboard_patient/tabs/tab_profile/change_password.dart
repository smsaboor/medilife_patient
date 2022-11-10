import 'package:flutter/material.dart';
import 'package:flutter_package1/CustomFormField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPD extends StatefulWidget {
  const ChangePasswordPD({Key? key}) : super(key: key);
  @override
  _ChangePasswordPDState createState() => _ChangePasswordPDState();
}

class _ChangePasswordPDState extends State<ChangePasswordPD> {
  final TextEditingController _controllerMobileNumber = TextEditingController();
  final TextEditingController _controllerAccountHolder = TextEditingController();
  String? name = ' ';
  String? number;

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    name = preferences.getString('name');
    number = preferences.getString('number');
    setState(() {});
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Change Password'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Center(
              child: Container(
                  width: MediaQuery.of(context).size.width * .95,
                  height: MediaQuery.of(context).size.height * .4,
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
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                          readOnly: false,
                          controlller: _controllerMobileNumber,
                          errorMsg: 'Enter Your Old Password',
                          labelText: 'Old Password',
                          icon: Icons.lock_open,
                          maxLimit: 8,
                          maxLimitError: '8',
                          textInputType: TextInputType.number),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                          readOnly: false,
                          controlller: _controllerAccountHolder,
                          errorMsg: 'Enter Your New Password',
                          labelText: 'New Password',
                          icon: Icons.lock_clock,
                          maxLimit: 8,
                          maxLimitError: '8',
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomFormField(
                          readOnly: false,
                          controlller: _controllerAccountHolder,
                          errorMsg: 'Enter Confirm Password',
                          labelText: 'Confirm Password',
                          icon: Icons.lock_clock,
                          maxLimit: 8,
                          maxLimitError: '8',
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .87,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: const Color(0xffe3075f),
                                textStyle: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                            child: const Text(
                              "Change",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
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
}
