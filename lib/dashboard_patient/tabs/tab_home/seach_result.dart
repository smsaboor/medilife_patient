import 'package:flutter/material.dart';
import 'package:medilife_patient/dashboard_patient/doctor/doctor_profile_page.dart';
import 'package:medilife_patient/dashboard_patient/widgets/popular_doctor.dart';
import 'package:flutter_package1/loading/loading_card_list.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key,required this.data,required this.userData}) : super(key: key);
final data;
final userData;
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.blue,
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              title: const Text('Searched Doctors'),
            ),
            const SizedBox(height: 20,),
            widget.data[0]['status'] == '0'
                ? Center(child: Text('${widget.data[0]['message']}'))
                : ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
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

          ],
        ),
      ),
    );
  }
}
