// To parse this JSON data, do
//
//     final showShiftSwapResponse = showShiftSwapResponseFromJson(jsonString);

import 'dart:convert';

ShowShiftSwapResponse showShiftSwapResponseFromJson(String str) =>
    ShowShiftSwapResponse.fromJson(json.decode(str));

String showShiftSwapResponseToJson(ShowShiftSwapResponse data) =>
    json.encode(data.toJson());

class ShowShiftSwapResponse {
  String? status;
  String? message;
  bool? error;
  List<ShowShiftSwapItem>? data;

  ShowShiftSwapResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory ShowShiftSwapResponse.fromJson(Map<String, dynamic> json) =>
      ShowShiftSwapResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: json['Data'] == null
            ? []
            : List<ShowShiftSwapItem>.from(
                json['Data']!.map((x) => ShowShiftSwapItem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error,
        'Data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShowShiftSwapItem {
  dynamic tanggalPengajuan;
  DateTime? tanggalTukar;
  String? shiftTukar;
  String? statusTukar;
  int? idTukarShift;
  String? user;
  String? userPengganti;
  String? alasan;
  String? levelApproval;

  ShowShiftSwapItem({
    this.tanggalPengajuan,
    this.tanggalTukar,
    this.shiftTukar,
    this.statusTukar,
    this.idTukarShift,
    this.user,
    this.userPengganti,
    this.alasan,
    this.levelApproval,
  });

  factory ShowShiftSwapItem.fromJson(Map<String, dynamic> json) =>
      ShowShiftSwapItem(
        tanggalPengajuan: json['tanggal_pengajuan'],
        tanggalTukar: json['tgl_tukar'] == null
            ? null
            : DateTime.tryParse(json['tgl_tukar'].toString()),
        shiftTukar: json['shift_tukar']?.toString(),
        statusTukar: (json['status_tukar'] ?? json['status'])?.toString(),
        idTukarShift:
            int.tryParse((json['id_tukar_shift'] ?? json['id_shift_swap'] ?? '').toString()),
        user: json['user']?.toString(),
        userPengganti:
            (json['user_pengganti'] ?? json['pengganti'])?.toString(),
        alasan: (json['alasan'] ?? json['keterangan'] ?? json['note'])?.toString(),
        levelApproval: json['level']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'tanggal_pengajuan': tanggalPengajuan,
        'tgl_tukar': tanggalTukar?.toIso8601String(),
        'shift_tukar': shiftTukar,
        'status_tukar': statusTukar,
        'id_tukar_shift': idTukarShift,
        'user': user,
        'user_pengganti': userPengganti,
        'alasan': alasan,
        'level': levelApproval,
      };
}

