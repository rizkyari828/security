// To parse this JSON data, do
//
//     final updateFcmProfileRequest = updateFcmProfileRequestFromJson(jsonString);

import 'dart:convert';
import 'package:get/get.dart';

UpdateFcmProfileRequest updateFcmProfileRequestFromJson(String str) => UpdateFcmProfileRequest.fromJson(json.decode(str));

String updateFcmProfileRequestToJson(UpdateFcmProfileRequest data) => json.encode(data.toJson());

class UpdateFcmProfileRequest {
    UpdateFcmProfileRequest({
        this.idUser,
        this.fcmId,
    });

    String? idUser;
    String? fcmId;

    factory UpdateFcmProfileRequest.fromJson(Map<String, dynamic> json) => UpdateFcmProfileRequest(
        idUser: (json["id_user"] ?? '').toString(),
        fcmId: (json["fcm_id"] ?? json["fcm_token"] ?? '').toString(),
    );

    Map<String, dynamic> toJson() => {
        "id_user": idUser == null ? null : idUser,
        "fcm_id": fcmId == null ? null : fcmId,
    };

    FormData toFormData() => FormData({
        "id_user": (idUser ?? '').trim(),
        "fcm_id": (fcmId ?? '').trim(),
    });
}
