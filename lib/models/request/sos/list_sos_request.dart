import 'dart:convert';

class ListSosRequest {
  ListSosRequest({required this.idUser});

  final String idUser;

  factory ListSosRequest.fromRawJson(String str) =>
      ListSosRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListSosRequest.fromJson(Map<String, dynamic> json) => ListSosRequest(
        idUser: (json['id_user'] ?? json['user_id'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {'id_user': idUser};
}

