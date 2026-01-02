import 'dart:convert';

PayslipListResponse payslipListResponseFromJson(String str) =>
    PayslipListResponse.fromJson(json.decode(str));

class PayslipListResponse {
  PayslipListResponse({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  String? message;
  bool? error;
  List<PayslipListItem>? data;

  factory PayslipListResponse.fromJson(Map<String, dynamic> json) =>
      PayslipListResponse(
        status: json['status']?.toString(),
        message: json['message']?.toString(),
        error: json['error'] == true,
        data: (json['Data'] is List)
            ? (json['Data'] as List)
                .whereType<Map>()
                .map((e) => PayslipListItem.fromJson(
                      Map<String, dynamic>.from(e),
                    ))
                .toList()
            : <PayslipListItem>[],
      );
}

class PayslipListItem {
  PayslipListItem({
    this.bulan,
    this.tahun,
    this.path,
  });

  String? bulan;
  int? tahun;
  String? path;

  factory PayslipListItem.fromJson(Map<String, dynamic> json) =>
      PayslipListItem(
        bulan: json['bulan']?.toString(),
        tahun: json['tahun'] is int
            ? json['tahun'] as int
            : int.tryParse('${json['tahun']}'),
        path: json['path']?.toString(),
      );
}
