import 'dart:convert';

class ShowClaimRequest {
  ShowClaimRequest({required this.id});

  final String id;

  factory ShowClaimRequest.fromRawJson(String str) =>
      ShowClaimRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShowClaimRequest.fromJson(Map<String, dynamic> json) =>
      ShowClaimRequest(
        id: (json['id_claim'] ?? json['id_klaim'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_claim': id,
      };
}

