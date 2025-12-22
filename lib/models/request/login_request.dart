import 'dart:convert';

class LoginRequest {
  LoginRequest({
    required this.username,
    this.password,
    this.kunci,
  });

  String username;
  String? password;
  String? kunci;

  factory LoginRequest.fromRawJson(String str) =>
      LoginRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
        username: json["username"],
        password: json["password"],
        kunci: json["kunci"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "kunci": kunci,
      };
}
