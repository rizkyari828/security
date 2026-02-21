// To parse this JSON data, do
//
//     final attendanceValidateResponse = attendanceValidateResponseFromJson(jsonString);

import 'dart:convert';

AttendanceValidateResponse attendanceValidateResponseFromJson(String str) =>
    AttendanceValidateResponse.fromJson(json.decode(str));

String attendanceValidateResponseToJson(AttendanceValidateResponse data) =>
    json.encode(data.toJson());

class AttendanceValidateResponse {
  AttendanceValidateResponse({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<ValidateData>? data;

  factory AttendanceValidateResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceValidateResponse(
        status: json["status"],
        message: json["message"].toString(),
        data: (json["Data"] is List)
            ? (json["Data"] as List)
                .whereType<Map>()
                .map((x) => ValidateData.fromJson(Map<String, dynamic>.from(x)))
                .toList()
            : <ValidateData>[],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message.toString(),
        "Data": List<dynamic>.from(
            (data ?? <ValidateData>[]).map((x) => x.toJson())),
      };
}

class ValidateData {
  ValidateData({
    this.flag,
    this.absenIn,
    this.absenOut,
    this.jarak,
    this.latitude,
    this.longitude,
    this.faceIdRaw,
  });

  String? flag;
  String? absenIn;
  String? absenOut;
  String? jarak;
  double? latitude, longitude;
  List<dynamic>? faceIdRaw;

  List<List<double>> get faceEmbeddings {
    final output = <List<double>>[];
    _extractEmbeddings(faceIdRaw, output);
    return output;
  }

  bool get hasValidFaceEmbeddings =>
      faceEmbeddings.any((embedding) => isValidEmbedding(embedding));

  factory ValidateData.fromJson(Map<String, dynamic> json) => ValidateData(
        flag: json["flag"] == null ? null : json["flag"],
        absenIn: json["absen_in"] == null ? "" : json["absen_in"],
        absenOut: json["absen_out"] == null ? "" : json["absen_out"],
        jarak: json["jarak"] == null ? null : json["jarak"],
        latitude: _toDouble(json["lat"]),
        longitude: _toDouble(json["long"]),
        faceIdRaw: _normalizeFaceIdRaw(json["face_id"]),
      );

  Map<String, dynamic> toJson() => {
        "flag": flag == null ? null : flag,
        "absen_in": absenIn == null ? "" : absenIn,
        "absen_out": absenOut == null ? "" : absenOut,
        "jarak": jarak == null ? null : jarak,
        "lat": latitude == null ? null : latitude,
        "long": longitude == null ? null : longitude,
        "face_id": faceIdRaw ?? <dynamic>[],
      };

  static bool isValidEmbedding(
    List<double> embedding, {
    int minLength = 64,
  }) {
    if (embedding.length < minLength) return false;
    if (embedding.any((x) => x.isNaN || x.isInfinite)) return false;
    final magnitude = embedding.fold<double>(0.0, (sum, x) => sum + (x * x));
    return magnitude > 0.0;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }
    return null;
  }

  static List<dynamic> _normalizeFaceIdRaw(dynamic value) {
    if (value == null) return <dynamic>[];
    if (value is List) return List<dynamic>.from(value);
    return <dynamic>[value];
  }

  static void _extractEmbeddings(dynamic source, List<List<double>> output) {
    if (source == null) return;

    if (source is String) {
      final trimmed = source.trim();
      if (trimmed.isEmpty ||
          trimmed == '[]' ||
          trimmed == '{}' ||
          trimmed.toLowerCase() == 'null') {
        return;
      }
      try {
        final decoded = json.decode(trimmed);
        _extractEmbeddings(decoded, output);
      } catch (_) {
        final cleaned = trimmed.replaceAll('[', '').replaceAll(']', '');
        if (cleaned.trim().isEmpty) return;
        final values = cleaned
            .split(',')
            .map((x) => double.tryParse(x.trim()))
            .whereType<double>()
            .toList(growable: false);
        if (values.isNotEmpty) output.add(values);
      }
      return;
    }

    if (source is Map) {
      if (source.isEmpty) return;
      for (final value in source.values) {
        _extractEmbeddings(value, output);
      }
      return;
    }

    if (source is List) {
      if (source.isEmpty) return;
      final allNumeric = source.every(
        (x) => x is num || (x is String && double.tryParse(x) != null),
      );
      if (allNumeric) {
        final values = source
            .map((x) => x is num ? x.toDouble() : double.parse(x.toString()))
            .toList(growable: false);
        if (values.isNotEmpty) output.add(values);
        return;
      }

      for (final item in source) {
        _extractEmbeddings(item, output);
      }
    }
  }
}
