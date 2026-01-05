// To parse this JSON data, do
//
//     final ProspekV2Response = ProspekV2ResponseFromJson(jsonString);

import 'dart:convert';

import 'package:staffku/models/response/prospek_v2/detail_prospek_v2_response.dart';

ProspekV2Response prospekV2ResponseFromJson(String str) =>
    ProspekV2Response.fromJson(json.decode(str));

String prospekV2ResponseToJson(ProspekV2Response data) =>
    json.encode(data.toJson());

class ProspekV2Response {
  ProspekV2Response({this.status, this.message, this.data});

  String? status;
  String? message;
  List<ProspekDetailV2>? data;

  factory ProspekV2Response.fromJson(Map<String, dynamic> json) =>
      ProspekV2Response(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["Data"] == null
            ? null
            : List<ProspekDetailV2>.from(
                json["Data"].map((x) => ProspekDetailV2.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "Data": data == null
        ? null
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
