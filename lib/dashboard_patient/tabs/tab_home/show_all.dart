import 'package:flutter/material.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/widgets/popular_doctor.dart';

class ShowAll extends StatefulWidget {
  const ShowAll({Key? key, required this.data, required this.userData, required this.title})
      : super(key: key);
  final data;
  final title;
final userData;
  @override
  State<ShowAll> createState() => _ShowAllState();
}

class _ShowAllState extends State<ShowAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),centerTitle: true,),
      body: SingleChildScrollView(child: Column(children: [
        SizedBox(height: 20,),
        widget.data[0]['status'] == '0'
            ? Center(child: Text('${widget.data[0]['message']}'))
            : ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0,right: 8,bottom: 15),
                  child: GestureDetector(
                    child: PopularDoctorPD(
                      doctor:  widget.data[index],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => DoctorProfilePagePD(
                            doctor: widget.data[index],
                            patient: widget.userData,
                          )));
                    },
                  ),
                ),
                onTap: () async {},
              );
            }),


    ],),),);
  }
}
