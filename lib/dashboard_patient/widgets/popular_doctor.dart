import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medilife_patient/core/constants.dart';
import 'avatar_image.dart';
import 'package:http/http.dart' as http;

class PopularDoctorPD extends StatefulWidget {
  PopularDoctorPD({Key? key, required this.doctor}) : super(key: key);
  var doctor;

  @override
  State<PopularDoctorPD> createState() => _PopularDoctorPDState();
}

class _PopularDoctorPDState extends State<PopularDoctorPD> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // print('saboor2---------------------${widget.doctor["image"]}');
    // print('saboor3---------------------${widget.doctor}');
    return Container(
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.only(left: 5, top: 15),
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.width * .45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              height: 140,
              width: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: widget.doctor["image"]??'https://images.unsplash.com/photo-1625498542602-6bfb30f39b3f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80'
                ),
              )
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0),
            //   child: AvatarImagePD(widget.doctor["image"]??'https://images.unsplash.com/photo-1625498542602-6bfb30f39b3f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80'),
            // ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital,
                      color: Colors.blue,
                      size: 26,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.doctor["clinic_name"] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor["doctor_name"] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '')  ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.doctor["degree"].toString().replaceAll('[', '').replaceAll(']', '')  ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            "Speaks: ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                          ),
                          Text(
                            widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '')  ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // Row(
                      //   children: [
                      //     Icon(
                      //       Icons.star,
                      //       color: Colors.yellow,
                      //       size: 14,
                      //     ),
                      //     SizedBox(
                      //       width: 2,
                      //     ),
                      //     Text(
                      //       "${doctor["review"]} Review",
                      //       style: TextStyle(fontSize: 12),
                      //     )
                      //   ],
                      // ),
                      Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: 120,
                              height: 30,
                              color: Colors.orange,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Fees: ${widget.doctor["doctor_fee"]??''}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
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
                )
              ],
            )
          ],
        ));
  }
}
