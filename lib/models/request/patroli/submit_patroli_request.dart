import 'dart:convert';

import 'package:get/get.dart';

class SubmitPatroliRequest {
  SubmitPatroliRequest({
    required this.idUser,
    required this.idJadwal,
    required this.keterangan,
    required this.foto,
  });

  final String idUser;
  final String idJadwal;
  final String keterangan;
  final MultipartFile foto;

  factory SubmitPatroliRequest.fromRawJson(String str) =>
      SubmitPatroliRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubmitPatroliRequest.fromJson(Map<String, dynamic> json) =>
      SubmitPatroliRequest(
        idUser: json['id_user']?.toString() ?? '',
        idJadwal: json['id_jadwal']?.toString() ?? '',
        keterangan: json['keterangan']?.toString() ?? '',
        foto: json['foto'],
      );

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
        'id_jadwal': idJadwal,
        'keterangan': keterangan,
        'foto': foto,
      };

  FormData toFormData() => FormData({
        'id_user': idUser,
        'id_jadwal': idJadwal,
        'keterangan': keterangan,
        'foto': foto,
      });
}

