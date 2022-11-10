import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medilife_patient/core/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  File? image ;
  final _picker = ImagePicker();
  bool showSpinner = false ;

  Future getImage()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 80);
    if(pickedFile!= null ){
      image = File(pickedFile.path);
      setState(() {
      });
    }else {
      print('no image selected');
    }
  }

  Future<void> uploadImage ()async{

    setState(() {
      showSpinner = true ;
    });

    var stream  = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();

    var uri = Uri.parse('${API_BASE_URL}update_image_api.php');

    var request =  http.MultipartRequest('POST', uri);

    request.fields['doctor_id'] = "7" ;

    var multiport = http.MultipartFile(
        'image',
        stream,
        length);

    request.files.add(multiport);
    var response = await request.send() ;
    if(response.statusCode == 200){
      setState(() {
        showSpinner = false ;
      });
    }else {
      setState(() {
        showSpinner = false ;
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                getImage();
              },
              child: Container(
                child: image == null ? const Center(child: Text('Pick Image'),)
                    :
                Center(
                  child: Image.file(
                    File(image!.path).absolute,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 150,),
            GestureDetector(
              onTap: (){
                uploadImage();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.green,
                child: const Center(child: Text('Upload')),
              ),
            )
          ],
        ),
      ),
    );
  }
}