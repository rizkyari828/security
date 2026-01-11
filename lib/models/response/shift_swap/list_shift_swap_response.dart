// To parse this JSON data, do
//
//     final shiftSwapListResponse = shiftSwapListResponseFromJson(jsonString);

import 'dart:convert';

ShiftSwapListResponse shiftSwapListResponseFromJson(String str) =>
    ShiftSwapListResponse.fromJson(json.decode(str));

String shiftSwapListResponseToJson(ShiftSwapListResponse data) =>
    json.encode(data.toJson());

class ShiftSwapListResponse {
  String? status;
  String? message;
  bool? error;
  List<ShiftSwapListItem>? data;

  ShiftSwapListResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory ShiftSwapListResponse.fromJson(Map<String, dynamic> json) =>
      ShiftSwapListResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: json['Data'] == null
            ? []
            : List<ShiftSwapListItem>.from(
                json['Data']!.map((x) => ShiftSwapListItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error,
        'Data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShiftSwapListItem {
  dynamic tanggalPengajuan;
  DateTime? tanggalTukar;
  String? shiftTukar;
  String? statusTukar;
  String? user;
  String? userPengganti;
  int? idTukarShift;
  String? levelApproval;

  ShiftSwapListItem({
    this.tanggalPengajuan,
    this.tanggalTukar,
    this.shiftTukar,
    this.statusTukar,
    this.user,
    this.userPengganti,
    this.idTukarShift,
    this.levelApproval,
  });

  factory ShiftSwapListItem.fromJson(Map<String, dynamic> json) =>
      ShiftSwapListItem(
        tanggalPengajuan: json['tanggal_pengajuan'],
        tanggalTukar: json['tgl_tukar'] == null
            ? null
            : DateTime.tryParse(json['tgl_tukar'].toString()),
        shiftTukar: json['shift_tukar']?.toString(),
        statusTukar: (json['status_tukar'] ?? json['status'])?.toString(),
        user: json['user']?.toString(),
        userPengganti:
            (json['user_pengganti'] ?? json['pengganti'])?.toString(),
        idTukarShift:
            int.tryParse((json['id_tukar_shift'] ?? json['id_shift_swap'] ?? '').toString()),
        levelApproval: json['level']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'tanggal_pengajuan': tanggalPengajuan,
        'tgl_tukar': tanggalTukar?.toIso8601String(),
        'shift_tukar': shiftTukar,
        'status_tukar': statusTukar,
        'user': user,
        'user_pengganti': userPengganti,
        'id_tukar_shift': idTukarShift,
        'level': levelApproval,
      };
}
