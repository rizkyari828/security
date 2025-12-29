// To parse this JSON data, do
//
//     final showClaimResponse = showClaimResponseFromJson(jsonString);

import 'dart:convert';

ShowClaimResponse showClaimResponseFromJson(String str) =>
    ShowClaimResponse.fromJson(json.decode(str));

String showClaimResponseToJson(ShowClaimResponse data) =>
    json.encode(data.toJson());

class ShowClaimResponse {
  String? status;
  String? message;
  bool? error;
  List<ShowClaimItem>? data;

  ShowClaimResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory ShowClaimResponse.fromJson(Map<String, dynamic> json) =>
      ShowClaimResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: json['Data'] == null
            ? []
            : List<ShowClaimItem>.from(
                json['Data']!.map((x) => ShowClaimItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error,
        'Data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShowClaimItem {
  dynamic tanggalPengajuan;
  DateTime? tanggalClaim;
  String? nominal;
  String? statusClaim;
  int? idClaim;
  String? user;
  String? keterangan;
  String? levelApproval;

  ShowClaimItem({
    this.tanggalPengajuan,
    this.tanggalClaim,
    this.nominal,
    this.statusClaim,
    this.idClaim,
    this.user,
    this.keterangan,
    this.levelApproval,
  });

  factory ShowClaimItem.fromJson(Map<String, dynamic> json) => ShowClaimItem(
        tanggalPengajuan: json['tanggal_pengajuan'],
        tanggalClaim: json['tgl_claim'] == null
            ? null
            : DateTime.tryParse(json['tgl_claim'].toString()),
        nominal: (json['nominal'] ?? json['amount'])?.toString(),
        statusClaim: (json['status_claim'] ?? json['status'])?.toString(),
        idClaim: int.tryParse((json['id_claim'] ?? json['id_klaim'] ?? '').toString()),
        user: json['user']?.toString(),
        keterangan: (json['keterangan'] ?? json['note'])?.toString(),
        levelApproval: json['level']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'tanggal_pengajuan': tanggalPengajuan,
        'tgl_claim': tanggalClaim?.toIso8601String(),
        'nominal': nominal,
        'status_claim': statusClaim,
        'id_claim': idClaim,
        'user': user,
        'keterangan': keterangan,
        'level': levelApproval,
      };
}

