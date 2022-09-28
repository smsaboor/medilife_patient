// To parse this JSON data, do
//
//     final modelProfile = modelProfileFromJson(jsonString);

import 'dart:convert';

List<ModelProfile> modelProfileFromJson(String str) => List<ModelProfile>.from(json.decode(str).map((x) => ModelProfile.fromJson(x)));

String modelProfileToJson(List<ModelProfile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class ModelProfile {
  ModelProfile({
    this.patient_id,
    this.patient_name,
    this.address,
    this.state,
    this.city,
    this.district,
    this.pincode,
  });

  String? patient_id;
  String? patient_name;
  String? address;
  String? state;
  String? city;
  String? district;
  String? pincode;


  factory ModelProfile.fromJson(Map<String, dynamic> json) => ModelProfile(
    patient_id: json["patient_id"],
    patient_name: json["patient_name"],
    address: json["address"],
    state: json["state"],
    city: json["city"],
    district: json["district"],
    pincode: json["pincode"],
  );

  Map<String, dynamic> toJson() => {
    "patient_id": patient_id,
    "patient_name": patient_name,
    "address": address,
    "state": state,
    "city": city,
    "district": district,
    "pincode": pincode,
  };
}
