import 'dart:convert';

SubmitShiftSwapRequest submitShiftSwapRequestFromJson(String str) =>
    SubmitShiftSwapRequest.fromJson(json.decode(str));

String submitShiftSwapRequestToJson(SubmitShiftSwapRequest data) =>
    json.encode(data.toJson());

class SubmitShiftSwapRequest {
  SubmitShiftSwapRequest({
    required this.userId,
    required this.tanggalTukar,
    required this.shiftTukar,
    required this.userIdPengganti,
  });

  final String userId;
  final String tanggalTukar;
  final String shiftTukar;
  final String userIdPengganti;

  factory SubmitShiftSwapRequest.fromJson(Map<String, dynamic> json) =>
      SubmitShiftSwapRequest(
        userId: json['user_id'] ?? '',
        tanggalTukar: json['tgl_tukar'] ?? '',
        shiftTukar: json['shift_tukar'] ?? '',
        userIdPengganti: json['user_id_pengganti'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'tgl_tukar': tanggalTukar,
        'shift_tukar': shiftTukar,
        'user_id_pengganti': userIdPengganti,
      };
}

