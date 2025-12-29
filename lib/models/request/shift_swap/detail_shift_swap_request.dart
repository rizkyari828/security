import 'dart:convert';

class ShowShiftSwapRequest {
  ShowShiftSwapRequest({required this.id});

  final String id;

  factory ShowShiftSwapRequest.fromRawJson(String str) =>
      ShowShiftSwapRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShowShiftSwapRequest.fromJson(Map<String, dynamic> json) =>
      ShowShiftSwapRequest(
        id: (json['id_tukar_shift'] ?? json['id_shift_swap'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_tukar_shift': id,
      };
}

