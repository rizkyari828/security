import 'dart:convert';

import 'package:get/get.dart';

class DetailShiftRequest {
  DetailShiftRequest({required this.id});

  final String id;

  factory DetailShiftRequest.fromRawJson(String str) =>
      DetailShiftRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailShiftRequest.fromJson(Map<String, dynamic> json) =>
      DetailShiftRequest(id: (json['id'] ?? '').toString());

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  FormData toFormData() => FormData(toJson());
}
