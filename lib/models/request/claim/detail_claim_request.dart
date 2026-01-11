import 'dart:convert';

import 'package:get/get.dart';

class ShowClaimRequest {
  ShowClaimRequest({required this.id, this.idUser});

  final String id;
  final String? idUser;

  factory ShowClaimRequest.fromRawJson(String str) =>
      ShowClaimRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShowClaimRequest.fromJson(Map<String, dynamic> json) =>
      ShowClaimRequest(
        id: (json['id'] ?? json['id_claim'] ?? json['id_klaim'] ?? '')
            .toString(),
        idUser: (json['id_user'] ?? json['user_id'])?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        if (idUser != null) 'id_user': idUser,
      };

  FormData toFormData() => FormData(toJson());
}
