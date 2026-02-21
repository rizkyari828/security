import 'dart:convert';

import 'package:get/get.dart';

SaveFaceRequest saveFaceRequestFromJson(String str) =>
    SaveFaceRequest.fromJson(json.decode(str));

String saveFaceRequestToJson(SaveFaceRequest data) =>
    json.encode(data.toJson());

class SaveFaceRequest {
  SaveFaceRequest({required this.idUser, required this.faceId});

  final String idUser;
  final String faceId;

  factory SaveFaceRequest.fromJson(Map<String, dynamic> json) =>
      SaveFaceRequest(
        idUser: (json['id_user'] ?? '').toString(),
        faceId: (json['face_id'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
    'id_user': idUser,
    'face_id': faceId,
  };

  FormData toFormData() => FormData({
    'id_user': idUser,
    'face_id': faceId,
  });
}
