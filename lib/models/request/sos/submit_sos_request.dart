import 'dart:convert';

import 'package:get/get.dart';

class SubmitSosRequest {
  SubmitSosRequest({
    required this.idUser,
    required this.keterangan,
    required this.foto,
  });

  final String idUser;
  final String keterangan;
  final MultipartFile foto;

  factory SubmitSosRequest.fromRawJson(String str) =>
      SubmitSosRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubmitSosRequest.fromJson(Map<String, dynamic> json) =>
      SubmitSosRequest(
        idUser: (json['id_user'] ?? json['user_id'] ?? '').toString(),
        keterangan: (json['keterangan'] ?? '').toString(),
        foto: json['foto'],
      );

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
        'keterangan': keterangan,
        'foto': foto,
      };

  FormData toFormData() => FormData(toJson());
}

