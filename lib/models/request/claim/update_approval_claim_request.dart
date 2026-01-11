import 'dart:convert';

UpdateApprovalClaimRequest updateApprovalClaimRequestFromJson(String str) =>
    UpdateApprovalClaimRequest.fromJson(json.decode(str));

String updateApprovalClaimRequestToJson(UpdateApprovalClaimRequest data) =>
    json.encode(data.toJson());

class UpdateApprovalClaimRequest {
  UpdateApprovalClaimRequest({
    this.id,
    this.action,
    this.noteApproval,
  });

  String? id;
  String? action;
  String? noteApproval;

  factory UpdateApprovalClaimRequest.fromJson(Map<String, dynamic> json) =>
      UpdateApprovalClaimRequest(
        id: (json['id_claim'] ?? json['id_klaim'])?.toString(),
        action: json['sts']?.toString(),
        noteApproval: (json['note'] ?? json['catatan'])?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_claim': id,
        'sts': action,
        'note': noteApproval,
      };
}
