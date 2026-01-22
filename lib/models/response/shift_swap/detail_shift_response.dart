import 'dart:convert';

DetailShiftResponse detailShiftResponseFromJson(String str) =>
    DetailShiftResponse.fromJson(json.decode(str));

String detailShiftResponseToJson(DetailShiftResponse data) =>
    json.encode(data.toJson());

class DetailShiftResponse {
  String? status;
  String? message;
  bool? error;
  List<DetailShiftItem>? data;

  DetailShiftResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory DetailShiftResponse.fromJson(Map<String, dynamic> json) =>
      DetailShiftResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: json['Data'] == null
            ? []
            : List<DetailShiftItem>.from(
                json['Data']!.map((x) => DetailShiftItem.fromJson(x)),
              ),
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

class DetailShiftItem {
  DetailShiftItem({
    this.id,
    this.shiftAfter,
    this.shiftBefore,
    this.tglTukar,
    this.note,
    this.noteTolak,
  });

  final int? id;
  final String? shiftAfter;
  final String? shiftBefore;
  final DateTime? tglTukar;
  final String? note;
  final String? noteTolak;

  DetailShiftItem copyWith({
    int? id,
    String? shiftAfter,
    String? shiftBefore,
    DateTime? tglTukar,
    String? note,
    String? noteTolak,
  }) {
    return DetailShiftItem(
      id: id ?? this.id,
      shiftAfter: shiftAfter ?? this.shiftAfter,
      shiftBefore: shiftBefore ?? this.shiftBefore,
      tglTukar: tglTukar ?? this.tglTukar,
      note: note ?? this.note,
      noteTolak: noteTolak ?? this.noteTolak,
    );
  }

  factory DetailShiftItem.fromJson(Map<String, dynamic> json) => DetailShiftItem(
        id: int.tryParse((json['id'] ?? '').toString()),
        shiftAfter: json['shift_after']?.toString(),
        shiftBefore: json['shift_before']?.toString(),
        tglTukar: json['tgl_tukar'] == null
            ? null
            : DateTime.tryParse(json['tgl_tukar'].toString()),
        note: json['note']?.toString(),
        noteTolak: json['note_tolak']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'shift_after': shiftAfter,
        'shift_before': shiftBefore,
        'tgl_tukar': tglTukar?.toIso8601String(),
        'note': note,
        'note_tolak': noteTolak,
      };
}
