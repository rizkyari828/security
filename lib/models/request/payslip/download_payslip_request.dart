import 'dart:convert';

DownloadPayslipRequest downloadPayslipRequestFromJson(String str) =>
    DownloadPayslipRequest.fromJson(json.decode(str));

String downloadPayslipRequestToJson(DownloadPayslipRequest data) =>
    json.encode(data.toJson());

class DownloadPayslipRequest {
  DownloadPayslipRequest({
    required this.userId,
    required this.month,
    required this.year,
  });

  final String userId;
  final String month;
  final String year;

  factory DownloadPayslipRequest.fromJson(Map<String, dynamic> json) =>
      DownloadPayslipRequest(
        userId: (json['user_id'] ?? '').toString(),
        month: (json['month'] ?? json['bulan'] ?? '').toString(),
        year: (json['year'] ?? json['tahun'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'month': month,
        'year': year,
      };

  Map<String, String> toQuery() => {
        'user_id': userId,
        'month': month,
        'year': year,
      };
}

