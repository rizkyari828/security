// To parse this JSON data, do
//
//     final SubmitAgentRequest = SubmitAgentRequestFromJson(jsonString);

import 'dart:convert';

import 'package:staffku/models/request/attendance/attendance_wrapper.dart';

SubmitAgentRequest SubmitAgentRequestFromJson(String str) =>
    SubmitAgentRequest.fromJson(json.decode(str));

String SubmitAgentRequestToJson(SubmitAgentRequest data) =>
    json.encode(data.toJson());

class SubmitAgentRequest {
  SubmitAgentRequest({
    this.idUser,
    this.fullName,
    this.agentName,
    this.email,
    this.alamat,
    this.placement,
    this.joinDate,
    this.typeAgentId,
    this.registerBy,
    this.statusActiveId,
    this.signature,
    this.photos,
  });

  String? idUser;
  String? fullName;
  String? agentName;
  String? email;
  String? alamat;
  String? placement;
  String? joinDate;
  String? typeAgentId;
  String? registerBy;
  String? statusActiveId;
  final List<PhotoAttachment>? signature;
  final List<PhotoAttachment>? photos;

  factory SubmitAgentRequest.fromJson(Map<String, dynamic> json) =>
      SubmitAgentRequest(
        idUser: json["user_id"],
        fullName: json["full_name"],
        agentName: json["agent_name"],
        email: json["email"],
        alamat: json["alamat"],
        placement: json["placement"],
        joinDate: json["join_date"],
        typeAgentId: json["type_agent_id"],
        registerBy: json["register_by"],
        statusActiveId: json["status_active_id"],
        signature: (json['signature'] as List? ?? [])
            .map((e) => PhotoAttachment.fromJson(e))
            .toList(),
        photos: (json['photos'] as List? ?? [])
            .map((e) => PhotoAttachment.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'user_id': idUser,
    'full_name': fullName,
    'agent_name': agentName,
    'email': email,
    'alamat': alamat,
    'placement': placement,
    'join_date': joinDate,
    'type_agent_id': typeAgentId,
    'register_by': registerBy,
    'status_active_id': statusActiveId,
    'signature': signature?.map((e) => e.toJson()).toList(),
    'photos': photos?.map((e) => e.toJson()).toList(),
  };
}
