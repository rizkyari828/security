import 'dart:convert';

import 'package:get/get.dart';

class ListClaimRequest {
  ListClaimRequest({required this.idUser});

  final String idUser;

  factory ListClaimRequest.fromRawJson(String str) =>
      ListClaimRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListClaimRequest.fromJson(Map<String, dynamic> json) =>
      ListClaimRequest(
        idUser: (json['id_user'] ?? json['user_id'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {'id_user': idUser};

  FormData toFormData() => FormData({'id_user': idUser});
}
