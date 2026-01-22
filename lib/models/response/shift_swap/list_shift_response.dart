import 'dart:convert';

ListShiftResponse listShiftResponseFromJson(String str) =>
    ListShiftResponse.fromJson(json.decode(str));

String listShiftResponseToJson(ListShiftResponse data) =>
    json.encode(data.toJson());

class ListShiftResponse {
  String? status;
  String? message;
  bool? error;
  List<ListShiftItem>? data;

  ListShiftResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  factory ListShiftResponse.fromJson(Map<String, dynamic> json) =>
      ListShiftResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: json['Data'] == null
            ? []
            : List<ListShiftItem>.from(
                json['Data']!.map((x) => ListShiftItem.fromJson(x)),
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

class ListShiftItem {
  ListShiftItem({
    this.id,
    this.nama,
    this.shiftAfter,
    this.shiftBefore,
    this.tglTukar,
    this.note,
    this.status,
    this.noteTolak,
  });

  final int? id;
  final String? nama;
  final String? shiftAfter;
  final String? shiftBefore;
  final DateTime? tglTukar;
  final String? note;
  final String? status;
  final String? noteTolak;

  factory ListShiftItem.fromJson(Map<String, dynamic> json) => ListShiftItem(
        id: int.tryParse((json['id'] ?? '').toString()),
        nama: json['nama']?.toString(),
        shiftAfter: json['shift_after']?.toString(),
        shiftBefore: json['shift_before']?.toString(),
        tglTukar: json['tgl_tukar'] == null
            ? null
            : DateTime.tryParse(json['tgl_tukar'].toString()),
        note: json['note']?.toString(),
        status: json['status']?.toString(),
        noteTolak: json['note_tolak']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'shift_after': shiftAfter,
        'shift_before': shiftBefore,
        'tgl_tukar': tglTukar?.toIso8601String(),
        'note': note,
        'status': status,
        'note_tolak': noteTolak,
      };
}
