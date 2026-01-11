import 'dart:convert';

import 'package:get/get.dart';

SubmitClaimRequest submitClaimRequestFromJson(String str) =>
    SubmitClaimRequest.fromJson(json.decode(str));

String submitClaimRequestToJson(SubmitClaimRequest data) =>
    json.encode(data.toJson());

class SubmitClaimRequest {
  SubmitClaimRequest({
    required this.idUser,
    required this.nominal,
    required this.keterangan,
    required this.foto,
  });

  final String idUser;
  final String nominal;
  final String keterangan;
  final MultipartFile foto;

  factory SubmitClaimRequest.fromJson(Map<String, dynamic> json) =>
      SubmitClaimRequest(
        idUser: (json['id_user'] ?? json['user_id'] ?? '').toString(),
        nominal: (json['nominal'] ?? json['amount'] ?? '').toString(),
        keterangan: (json['keterangan'] ?? json['note'] ?? '').toString(),
        foto: json['foto'],
      );

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
        'nominal': nominal,
        'keterangan': keterangan,
        'foto': foto,
      };

  FormData toFormData() => FormData(toJson());
}
