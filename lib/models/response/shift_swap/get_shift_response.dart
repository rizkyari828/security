import 'dart:convert';

GetShiftResponse getShiftResponseFromJson(String str) =>
    GetShiftResponse.fromJson(json.decode(str));

String getShiftResponseToJson(GetShiftResponse data) => json.encode(data.toJson());

class GetShiftResponse {
  GetShiftResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  final String? status;
  final String? message;
  final bool? error;
  final List<ShiftOption>? data;

  factory GetShiftResponse.fromJson(Map<String, dynamic> json) => GetShiftResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: json['Data'] == null
            ? []
            : List<ShiftOption>.from(
                json['Data']!.map((x) => ShiftOption.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'error': error,
        'Data': data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ShiftOption {
  const ShiftOption({
    this.idShift,
    this.kodeShift,
    this.namaShift,
  });

  final int? idShift;
  final String? kodeShift;
  final String? namaShift;

  factory ShiftOption.fromJson(Map<String, dynamic> json) => ShiftOption(
        idShift: int.tryParse((json['id_shift'] ?? '').toString()),
        kodeShift: json['kode_shift']?.toString(),
        namaShift: json['nama_shift']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_shift': idShift,
        'kode_shift': kodeShift,
        'nama_shift': namaShift,
      };

  String get label {
    final name = (namaShift ?? '').trim();
    final code = (kodeShift ?? '').trim();

    if (name.isEmpty) return code;
    if (code.isEmpty) return name;
    return '$name ($code)';
  }

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      other is ShiftOption && other.idShift == idShift;

  @override
  int get hashCode => idShift.hashCode;
}

