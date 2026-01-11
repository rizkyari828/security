import 'dart:convert';

PatroliListResponse patroliListResponseFromJson(String str) =>
    PatroliListResponse.fromJson(json.decode(str));

String patroliListResponseToJson(PatroliListResponse data) =>
    json.encode(data.toJson());

class PatroliListResponse {
  PatroliListResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  String? message;
  bool? error;
  List<PatroliListItem>? data;

  factory PatroliListResponse.fromJson(Map<String, dynamic> json) =>
      PatroliListResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: () {
          final raw = json['Data'];
          if (raw is! List) return <PatroliListItem>[];
          return raw
              .map(
                (x) => PatroliListItem.fromJson(
                  Map<String, dynamic>.from(x as Map),
                ),
              )
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

class PatroliListItem {
  PatroliListItem({
    this.id,
    this.idJadwal,
    this.namaJadwal,
    this.status,
    this.raw,
  });

  String? id;
  String? idJadwal;
  String? namaJadwal;
  String? status;
  Map<String, dynamic>? raw;

  factory PatroliListItem.fromJson(Map<String, dynamic> json) => PatroliListItem(
        id: json['id']?.toString(),
        idJadwal: json['id_jadwal']?.toString(),
        namaJadwal: json['nama_jadwal']?.toString(),
        status: json['status']?.toString(),
        raw: json,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_jadwal': idJadwal,
        'nama_jadwal': namaJadwal,
        'status': status,
        'raw': raw,
      };
}
