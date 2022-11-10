import 'package:flutter/material.dart';
import 'package:medilife_patient/core/constatnts/urls.dart';

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
  print('object----------------------------${widget.doctor["clinic_name"]}');
    return Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.only(left: 5, top: 15),
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
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              width: 110,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loading.gif',
                    image: widget.doctor["image"]??AppUrls.user
                ),
              )
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      color: Colors.blue,
                      size: 26,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.doctor["clinic_name"].length > 25 ? widget.doctor["clinic_name"].substring(0, 25)+'...' : widget.doctor["clinic_name"] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor["doctor_name"].length > 25 ? widget.doctor["doctor_name"].substring(0, 25)+'...' : widget.doctor["doctor_name"] ?? '',
                        // widget.doctor["doctor_name"] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '').length > 30 ?
                        '${widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '').substring(0, 30)}...' : widget.doctor["specialty"].toString().replaceAll('[', '').replaceAll(']', '') ??'',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                          widget.doctor["degree"].toString().replaceAll('[', '').replaceAll(']', '').length > 30 ?
                          '${widget.doctor["degree"].toString().replaceAll('[', '').replaceAll(']', '').substring(0, 30)}...' :
                          widget.doctor["degree"].toString().replaceAll('[', '').replaceAll(']', '') ??'',
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          const Text(
                            "Speaks: ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue),
                          ),
                          Text(
                            widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '').length > 28 ?
                            '${widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '').substring(0, 28)}...' :
                            widget.doctor["languages"].toString().replaceAll('[', '').replaceAll(']', '') ??'',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                                      'Fees: ${widget.doctor["doctor_fee"]?? ''}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}
