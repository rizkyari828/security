import 'dart:convert';

ListMenuResponse listMenuResponseFromJson(String str) =>
    ListMenuResponse.fromJson(json.decode(str));

String listMenuResponseToJson(ListMenuResponse data) => json.encode(
      data.toJson(),
    );

class ListMenuResponse {
  ListMenuResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  String? message;
  bool? error;
  List<MenuItem>? data;

  factory ListMenuResponse.fromJson(Map<String, dynamic> json) =>
      ListMenuResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] is bool ? json['error'] as bool : null,
        data: (json['Data'] is List)
            ? (json['Data'] as List)
                .whereType<Map>()
                .map((x) => MenuItem.fromJson(Map<String, dynamic>.from(x)))
                .toList()
            : <MenuItem>[],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error,
        'Data': List<dynamic>.from((data ?? <MenuItem>[]).map((x) => x.toJson())),
      };
}

class MenuItem {
  MenuItem({
    this.idMenu,
    this.namaMenu,
  });

  int? idMenu;
  String? namaMenu;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        idMenu: _asInt(json['id_menu']),
        namaMenu: json['nama_menu']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_menu': idMenu,
        'nama_menu': namaMenu,
      };
}

int? _asInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
