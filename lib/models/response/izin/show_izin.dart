// To parse this JSON data, do
//
//     final showIzinResponse = showIzinResponseFromJson(jsonString);

import 'dart:convert';

ShowIzinResponse showIzinResponseFromJson(String str) => ShowIzinResponse.fromJson(json.decode(str));

String showIzinResponseToJson(ShowIzinResponse data) => json.encode(data.toJson());

class ShowIzinResponse {
    ShowIzinResponse({
        this.status,
        this.message,
        this.error,
        this.data,
    });

    String? status;
    String? message;
    bool? error;
    List<DataIzin>? data;

    factory ShowIzinResponse.fromJson(Map<String, dynamic> json) => ShowIzinResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        error: json["error"] == null ? null : json["error"],
        data: json["Data"] == null ? null : List<DataIzin>.from(json["Data"].map((x) => DataIzin.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "error": error == null ? null : error,
        "Data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class DataIzin {
    DataIzin({
        this.id,
        this.kodeIjin,
        this.dateIn,
        this.dateOut,
        this.keterangan,
        this.statusIjin,
        this.levelApproval,
    });

    int? id;
    String? kodeIjin;
    DateTime? dateIn;
    DateTime? dateOut;
    String? keterangan;
    String? statusIjin;
    String? levelApproval;

    factory DataIzin.fromJson(Map<String, dynamic> json) => DataIzin(
        id: json["id"] == null ? null : json["id"],
        kodeIjin: json["kode_ijin"] == null ? null : json["kode_ijin"],
        dateIn: json["date_in"] == null ? null : DateTime.parse(json["date_in"]),
        dateOut: json["date_out"] == null ? null : DateTime.parse(json["date_out"]),
        keterangan: json["keterangan"] == null ? null : json["keterangan"],
        statusIjin: (json["status_ijin"] ??
                json["status_izin"] ??
                json["status"] ??
                json["status_leave"])
            ?.toString(),
        levelApproval: (json["level"] ??
                json["level_approval"] ??
                json["levelApproval"] ??
                json["approval_level"])
            ?.toString(),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "kode_ijin": kodeIjin == null ? null : kodeIjin,
        "date_in": dateIn == null ? null : "${dateIn?.year.toString().padLeft(4, '0')}-${dateIn?.month.toString().padLeft(2, '0')}-${dateIn?.day.toString().padLeft(2, '0')}",
        "date_out": dateOut == null ? null : "${dateOut?.year.toString().padLeft(4, '0')}-${dateOut?.month.toString().padLeft(2, '0')}-${dateOut?.day.toString().padLeft(2, '0')}",
        "keterangan": keterangan == null ? null : keterangan,
        "status_ijin": statusIjin,
        "level": levelApproval,
    };
}
