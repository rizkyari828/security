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
        'Data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShowClaimItem {
  int? id;
  DateTime? tanggal;
  String? keterangan;
  int? nominal;
  String? status;
  String? note;
  String? fotoUrl;

  ShowClaimItem({
    this.id,
    this.tanggal,
    this.keterangan,
    this.nominal,
    this.status,
    this.note,
    this.fotoUrl,
  });

  factory ShowClaimItem.fromJson(Map<String, dynamic> json) => ShowClaimItem(
        id: _tryParseInt(json['id'] ?? json['id_claim'] ?? json['id_klaim']),
        tanggal: _tryParseDateTime(json['tanggal'] ?? json['tgl_claim']),
        keterangan: json['keterangan']?.toString(),
        nominal: _tryParseInt(json['nominal'] ?? json['amount']),
        status:
            (json['sts'] ?? json['status_claim'] ?? json['status'])?.toString(),
        note: (json['note'] ?? json['catatan'])?.toString(),
        fotoUrl: (json['foto'] ?? json['img'])?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tanggal': tanggal?.toIso8601String(),
        'keterangan': keterangan,
        'nominal': nominal,
        'sts': status,
        'note': note,
        'foto': fotoUrl,
      };
}

int? _tryParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

DateTime? _tryParseDateTime(dynamic value) {
  if (value == null) return null;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;

  final normalized = raw.contains(' ') && !raw.contains('T')
      ? raw.replaceFirst(' ', 'T')
      : raw;
  return DateTime.tryParse(normalized);
}
