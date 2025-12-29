import 'dart:convert';

UpdateApprovalShiftSwapRequest updateApprovalShiftSwapRequestFromJson(
        String str) =>
    UpdateApprovalShiftSwapRequest.fromJson(json.decode(str));

String updateApprovalShiftSwapRequestToJson(UpdateApprovalShiftSwapRequest data) =>
    json.encode(data.toJson());

class UpdateApprovalShiftSwapRequest {
  UpdateApprovalShiftSwapRequest({
    this.id,
    this.action,
    this.noteApproval,
  });

  String? id;
  String? action;
  String? noteApproval;

  factory UpdateApprovalShiftSwapRequest.fromJson(Map<String, dynamic> json) =>
      UpdateApprovalShiftSwapRequest(
        id: (json['id_tukar_shift'] ?? json['id_shift_swap'])?.toString(),
        action: json['sts']?.toString(),
        noteApproval: json['note']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_tukar_shift': id,
        'sts': action,
        'note': noteApproval,
      };
}

