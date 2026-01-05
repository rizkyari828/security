// To parse this JSON data, do
//
//     final SubmitProspectV2Response = SubmitProspectV2ResponseFromJson(jsonString);

import 'dart:convert';

import 'package:staffku/models/response/prospek_v2/detail_prospek_v2_response.dart';

SubmitProspectV2Response submitProspectV2ResponseFromJson(String str) =>
    SubmitProspectV2Response.fromJson(json.decode(str));

String submitProspectV2ResponseToJson(SubmitProspectV2Response data) =>
    json.encode(data.toJson());

class SubmitProspectV2Response {
  SubmitProspectV2Response({this.error, this.message, this.data});

  bool? error;
  String? message;
  ProspekDetailV2? data;

  factory SubmitProspectV2Response.fromJson(Map<String, dynamic> json) =>
      SubmitProspectV2Response(
        error: json["error"] == null ? null : json["error"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : ProspekDetailV2.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "error": error == null ? null : error,
    "message": message == null ? null : message,
    "data": data == null ? null : data?.toJson(),
  };
}
