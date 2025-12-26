// To parse this JSON data, do
//
//     final attendanceValidateResponse = attendanceValidateResponseFromJson(jsonString);

import 'dart:convert';

AttendanceValidateResponse attendanceValidateResponseFromJson(String str) =>
    AttendanceValidateResponse.fromJson(json.decode(str));

String attendanceValidateResponseToJson(AttendanceValidateResponse data) =>
    json.encode(data.toJson());

class AttendanceValidateResponse {
  AttendanceValidateResponse({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<ValidateData>? data;

  factory AttendanceValidateResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceValidateResponse(
        status: json["status"],
        message: json["message"].toString(),
        data: (json["Data"] is List)
            ? (json["Data"] as List)
                .whereType<Map>()
                .map((x) => ValidateData.fromJson(Map<String, dynamic>.from(x)))
                .toList()
            : <ValidateData>[],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message.toString(),
        "Data": List<dynamic>.from(
            (data ?? <ValidateData>[]).map((x) => x.toJson())),
      };
}

class ValidateData {
  ValidateData({
    this.flag,
    this.absenIn,
    this.absenOut,
    this.jarak,
    this.latitude,
    this.longitude,
  });

  String? flag;
  String? absenIn;
  String? absenOut;
  String? jarak;
  double? latitude, longitude;

  factory ValidateData.fromJson(Map<String, dynamic> json) => ValidateData(
        flag: json["flag"] == null ? null : json["flag"],
        absenIn: json["absen_in"] == null ? "" : json["absen_in"],
        absenOut: json["absen_out"] == null ? "" : json["absen_out"],
        jarak: json["jarak"] == null ? null : json["jarak"],
        latitude: json["lat"] == null || json["lat"] == '' ? null : json["lat"],
        longitude:
            json["long"] == null || json["long"] == '' ? null : json["long"],
      );

  Map<String, dynamic> toJson() => {
        "flag": flag == null ? null : flag,
        "absen_in": absenIn == null ? "" : absenIn,
        "absen_out": absenOut == null ? "" : absenOut,
        "jarak": jarak == null ? null : jarak,
        "lat": latitude == null ? null : latitude,
        "long": longitude == null ? null : longitude
      };
}
