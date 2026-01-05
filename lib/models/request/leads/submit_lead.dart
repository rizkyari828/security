// To parse this JSON data, do
//
//     final SubmitLeadRequest = SubmitLeadRequestFromJson(jsonString);

import 'dart:convert';

import 'package:staffku/models/request/attendance/attendance_wrapper.dart';

SubmitLeadRequest SubmitLeadRequestFromJson(String str) =>
    SubmitLeadRequest.fromJson(json.decode(str));

String SubmitLeadRequestToJson(SubmitLeadRequest data) =>
    json.encode(data.toJson());

class SubmitLeadRequest {
  SubmitLeadRequest({
    this.idUser,
    this.date,
    this.leadSource,
    this.optionLeadSource,
    this.email,
    this.name,
    this.noHp,
    this.latitude,
    this.longitude,
    this.leadCategory,
    this.minatProduct,
    this.leadStatus,
    this.note,
    this.photos,
    this.alamat,
    this.gender,
    this.age,
    this.statusPekerjaan,
  });

  String? idUser;
  String? date;
  int? leadSource;
  String? optionLeadSource;
  String? email;
  String? name;
  String? noHp;
  String? latitude;
  String? longitude;
  int? leadCategory;
  String? minatProduct;
  int? leadStatus;
  String? note;
  String? alamat;
  final List<PhotoAttachment>? photos;
  String? age, gender, statusPekerjaan;

  factory SubmitLeadRequest.fromJson(Map<String, dynamic> json) =>
      SubmitLeadRequest(
        idUser: json["user_id"],
        date: json["date"],
        leadSource: json["sumber_leads"],
        optionLeadSource: json["sumber_leads2"],
        email: json["email"],
        name: json["nama"],
        noHp: json["telphone"],
        latitude: json["lat"],
        longitude: json["long"],
        leadCategory: json["kategori_leads"],
        minatProduct: json["product_minat"],
        leadStatus: json["status_leads"],
        note: json["catatan"],
        alamat: json["alamat"],
        gender: json["jenis_kelamin"],
        age: json["umur"],
        statusPekerjaan: json["status_pekerjaan"],
        photos: (json['foto'] as List? ?? [])
            .map((e) => PhotoAttachment.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'user_id': idUser,
    'date': date,
    'sumber_leads': leadSource,
    'sumber_leads2': optionLeadSource,
    'email': email,
    'nama': name,
    'telphone': noHp,
    'lat': latitude,
    'long': longitude,
    'kategori_leads': leadCategory,
    'product_minat': minatProduct,
    'status_leads': leadStatus,
    'catatan': note,
    'alamat': alamat,
    'jenis_kelamin': gender,
    'umur': age,
    'status_pekerjaan': statusPekerjaan,
    'foto': photos?.map((e) => e.toJson()).toList(),
  };
}
