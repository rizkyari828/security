// To parse this JSON data, do
//
//     final submitKuisionerRequest = submitKuisionerRequestFromJson(jsonString);

import 'dart:convert';

import 'package:staffku/models/request/attendance/attendance_wrapper.dart';

SubmitKuisionerRequest submitKuisionerRequestFromJson(String str) =>
    SubmitKuisionerRequest.fromJson(json.decode(str));

String submitKuisionerRequestToJson(SubmitKuisionerRequest data) =>
    json.encode(data.toJson());

class SubmitKuisionerRequest {
  List<SubmitKuisioner>? data;

  SubmitKuisionerRequest({this.data});

  factory SubmitKuisionerRequest.fromJson(Map<String, dynamic> json) =>
      SubmitKuisionerRequest(
        data: json["Data"] == null
            ? []
            : List<SubmitKuisioner>.from(
                json["Data"]!.map((x) => SubmitKuisioner.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "Data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SubmitKuisioner {
  String? idSoal;
  String? idKategori;
  String? jawaban;
  int? idTrans;
  final List<PhotoAttachment>? photos;

  SubmitKuisioner({
    this.idSoal,
    this.idKategori,
    this.jawaban,
    this.idTrans,
    this.photos,
  });

  factory SubmitKuisioner.fromJson(Map<String, dynamic> json) =>
      SubmitKuisioner(
        idSoal: json["id_soal"],
        idKategori: json["id_kategori"],
        jawaban: json["jawaban"],
        idTrans: json["id_trans"],
        photos: (json['foto'] as List? ?? [])
            .map((e) => PhotoAttachment.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    "id_soal": idSoal,
    "id_kategori": idKategori,
    "jawaban": jawaban,
    "id_trans": idTrans,
    'foto': photos?.map((e) => e.toJson()).toList(),
  };
}
