// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

RecapHistoryResponse recapHistoryResponseFromJson(String str) =>
    RecapHistoryResponse.fromJson(json.decode(str));

String recapHistoryResponseToJson(RecapHistoryResponse data) =>
    json.encode(data.toJson());

class RecapHistoryResponse {
  RecapHistoryResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  String? message;
  bool? error;
  List<DataHistory>? data;

  factory RecapHistoryResponse.fromJson(Map<String, dynamic> json) =>
      RecapHistoryResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        error: json["error"] == null ? null : json["error"],
        data: (json["Data"] is List)
            ? (json["Data"] as List)
                .whereType<Map>()
                .map((x) => DataHistory.fromJson(Map<String, dynamic>.from(x)))
                .toList()
            : <DataHistory>[],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "error": error == null ? null : error,
        "Data": List<dynamic>.from(
            (data ?? <DataHistory>[]).map((x) => x.toJson())),
      };
}

class DataHistory {
  DataHistory({
    this.absenIn,
    this.absenOut,
    this.tanggal,
    this.sts,
  });

  String? absenIn;
  String? absenOut;
  DateTime? tanggal;
  int? sts;

  factory DataHistory.fromJson(Map<String, dynamic> json) => DataHistory(
        absenIn: json["absenIn"] == null ? null : json["absenIn"],
        absenOut: json["absenOut"] == null ? null : json["absenOut"],
        tanggal:
            json["tanggal"] == null ? null : DateTime.parse(json["tanggal"]),
        sts: json["sts"] == null ? null : json["sts"],
      );

  Map<String, dynamic> toJson() => {
        "absenIn": absenIn == null ? null : absenIn,
        "absenOut": absenOut == null ? null : absenOut,
        "tanggal": tanggal == null
            ? null
            : "${tanggal?.year.toString().padLeft(4, '0')}-${tanggal?.month.toString().padLeft(2, '0')}-${tanggal?.day.toString().padLeft(2, '0')}",
        "sts": sts == null ? null : sts,
      };
}
