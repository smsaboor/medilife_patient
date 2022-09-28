
import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

enum SingingCharacter { Normal, Emergency }

class BookingScheduledPD extends StatefulWidget {
  const BookingScheduledPD({Key? key})
      : super(key: key);

  @override
  _BookingScheduledPDState createState() => _BookingScheduledPDState();
}

class _BookingScheduledPDState extends State<BookingScheduledPD> {
  SingingCharacter? _character = SingingCharacter.Normal;
  int index = 0;
  bool isAnimation=true;
  final TextEditingController _startDateController =
  new TextEditingController();
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 2200),
          () {
            setState(() {
              isAnimation=false;
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Booking Scheduled",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: getBody(),
    );
  }

  getBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ContactBox(icon: Icons.videocam_rounded, color: Colors.blue,),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.width,
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
                    child: Container(
                      child: Center(
                        child: FlareActor(
                          "assets/animations/Success Check.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: "Untitled",
                          isPaused: isAnimation,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
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
}
