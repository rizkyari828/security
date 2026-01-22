import 'dart:convert';

import 'package:get/get.dart';

ApproveShiftRequest approveShiftRequestFromJson(String str) =>
    ApproveShiftRequest.fromJson(json.decode(str));

String approveShiftRequestToJson(ApproveShiftRequest data) =>
    json.encode(data.toJson());

class ApproveShiftRequest {
  ApproveShiftRequest({
    required this.id,
    required this.sts,
    required this.note,
  });

  final String id;
  final String sts;
  final String note;

  factory ApproveShiftRequest.fromJson(Map<String, dynamic> json) =>
      ApproveShiftRequest(
        id: (json['id'] ?? '').toString(),
        sts: (json['sts'] ?? '').toString(),
        note: (json['note'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sts': sts,
        'note': note,
      };

  FormData toFormData() => FormData(toJson());
}

