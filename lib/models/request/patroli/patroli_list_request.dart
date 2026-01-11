import 'dart:convert';

import 'package:get/get.dart';

class PatroliListRequest {
  PatroliListRequest({required this.idUser});

  final String idUser;

  factory PatroliListRequest.fromRawJson(String str) =>
      PatroliListRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PatroliListRequest.fromJson(Map<String, dynamic> json) =>
      PatroliListRequest(idUser: json['id_user']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'id_user': idUser};

  FormData toFormData() => FormData({'id_user': idUser});
}

