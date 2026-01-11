import 'dart:convert';

PatroliDetailResponse patroliDetailResponseFromJson(String str) =>
    PatroliDetailResponse.fromJson(json.decode(str));

String patroliDetailResponseToJson(PatroliDetailResponse data) =>
    json.encode(data.toJson());

class PatroliDetailResponse {
  PatroliDetailResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  String? message;
  bool? error;
  List<PatroliDetailData>? data;

  factory PatroliDetailResponse.fromJson(Map<String, dynamic> json) =>
      PatroliDetailResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: () {
          final raw = json['Data'];
          if (raw is! List) return <PatroliDetailData>[];
          return raw
              .map(
                (x) => PatroliDetailData.fromJson(
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

class PatroliDetailData {
  PatroliDetailData({this.keterangan, this.foto});

  String? keterangan;
  String? foto;

  factory PatroliDetailData.fromJson(Map<String, dynamic> json) =>
      PatroliDetailData(
        keterangan: json['keterangan']?.toString(),
        foto: json['foto']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'keterangan': keterangan,
        'foto': foto,
      };
}
