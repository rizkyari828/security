import 'dart:convert';

import 'package:get/get.dart';

class PatroliIdRequest {
  PatroliIdRequest({required this.id});

  final String id;

  factory PatroliIdRequest.fromRawJson(String str) =>
      PatroliIdRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PatroliIdRequest.fromJson(Map<String, dynamic> json) =>
      PatroliIdRequest(id: json['id']?.toString() ?? '');

  Map<String, dynamic> toJson() => {'id': id};

  FormData toFormData() => FormData({'id': id});
}

