import 'dart:convert';

SosListResponse sosListResponseFromJson(String str) =>
    SosListResponse.fromJson(json.decode(str));

String sosListResponseToJson(SosListResponse data) =>
    json.encode(data.toJson());

class SosListResponse {
  SosListResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  String? message;
  bool? error;
  List<SosListItem>? data;

  factory SosListResponse.fromJson(Map<String, dynamic> json) => SosListResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: () {
          final raw = json['Data'];
          if (raw is! List) return <SosListItem>[];
          return raw
              .whereType<Map>()
              .map((x) => SosListItem.fromJson(Map<String, dynamic>.from(x)))
              .toList();
        }(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error,
        'Data': data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SosListItem {
  SosListItem({
    this.id,
    this.user,
    this.keterangan,
    this.cdate,
    this.img,
  });

  int? id;
  String? user;
  String? keterangan;
  DateTime? cdate;
  String? img;

  factory SosListItem.fromJson(Map<String, dynamic> json) => SosListItem(
        id: _tryParseInt(json['id']),
        user: json['user']?.toString(),
        keterangan: json['keterangan']?.toString(),
        cdate: _tryParseDate(json['cdate']),
        img: (json['img'] ?? json['foto'])?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'keterangan': keterangan,
        'cdate': cdate?.toIso8601String(),
        'img': img,
      };
}

int? _tryParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

DateTime? _tryParseDate(dynamic value) {
  if (value == null) return null;
  final raw = value.toString().trim();
  if (raw.isEmpty) return null;
  final normalized = raw.contains(' ') && !raw.contains('T')
      ? raw.replaceFirst(' ', 'T')
      : raw;
  return DateTime.tryParse(normalized);
}

