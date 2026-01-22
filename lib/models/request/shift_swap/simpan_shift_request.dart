import 'dart:convert';

import 'package:get/get.dart';

SimpanShiftRequest simpanShiftRequestFromJson(String str) =>
    SimpanShiftRequest.fromJson(json.decode(str));

String simpanShiftRequestToJson(SimpanShiftRequest data) =>
    json.encode(data.toJson());

class SimpanShiftRequest {
  SimpanShiftRequest({
    required this.idShift,
    required this.tanggal,
    required this.note,
    required this.idUser,
  });

  final String idShift;
  final String tanggal;
  final String note;
  final String idUser;

  factory SimpanShiftRequest.fromJson(Map<String, dynamic> json) =>
      SimpanShiftRequest(
        idShift: (json['id_shift'] ?? '').toString(),
        tanggal: (json['tanggal'] ?? '').toString(),
        note: (json['note'] ?? '').toString(),
        idUser: (json['id_user'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_shift': idShift,
        'tanggal': tanggal,
        'note': note,
        'id_user': idUser,
      };

  FormData toFormData() => FormData(toJson());
}
