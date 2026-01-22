import 'dart:convert';

import 'package:get/get.dart';

ListShiftRequest listShiftRequestFromJson(String str) =>
    ListShiftRequest.fromJson(json.decode(str));

String listShiftRequestToJson(ListShiftRequest data) => json.encode(data.toJson());

class ListShiftRequest {
  ListShiftRequest({required this.idUser});

  final String idUser;

  factory ListShiftRequest.fromJson(Map<String, dynamic> json) =>
      ListShiftRequest(idUser: (json['id_user'] ?? '').toString());

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
      };

  FormData toFormData() => FormData(toJson());
}
