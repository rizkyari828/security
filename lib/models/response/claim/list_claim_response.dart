// To parse this JSON data, do
//
//     final claimListResponse = claimListResponseFromJson(jsonString);

import 'dart:convert';

ClaimListResponse claimListResponseFromJson(String str) =>
    ClaimListResponse.fromJson(json.decode(str));

String claimListResponseToJson(ClaimListResponse data) =>
    json.encode(data.toJson());

class ClaimListResponse {
  String? status;
  String? message;
  bool? error;
  List<ClaimListItem>? data;

  ClaimListResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory ClaimListResponse.fromJson(Map<String, dynamic> json) =>
      ClaimListResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: json['Data'] == null
            ? []
            : List<ClaimListItem>.from(
                json['Data']!.map((x) => ClaimListItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error,
        'Data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ClaimListItem {
  dynamic tanggalPengajuan;
  DateTime? tanggalClaim;
  String? nominal;
  String? statusClaim;
  String? user;
  int? idClaim;
  String? levelApproval;

  ClaimListItem({
    this.tanggalPengajuan,
    this.tanggalClaim,
    this.nominal,
    this.statusClaim,
    this.user,
    this.idClaim,
    this.levelApproval,
  });

  factory ClaimListItem.fromJson(Map<String, dynamic> json) => ClaimListItem(
        tanggalPengajuan: json['tanggal_pengajuan'],
        tanggalClaim: json['tgl_claim'] == null
            ? null
            : DateTime.tryParse(json['tgl_claim'].toString()),
        nominal: (json['nominal'] ?? json['amount'])?.toString(),
        statusClaim: (json['status_claim'] ?? json['status'])?.toString(),
        user: json['user']?.toString(),
        idClaim: int.tryParse((json['id_claim'] ?? json['id_klaim'] ?? '').toString()),
        levelApproval: json['level']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'tanggal_pengajuan': tanggalPengajuan,
        'tgl_claim': tanggalClaim?.toIso8601String(),
        'nominal': nominal,
        'status_claim': statusClaim,
        'user': user,
        'id_claim': idClaim,
        'level': levelApproval,
      };
}

