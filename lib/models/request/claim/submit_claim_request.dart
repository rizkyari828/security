import 'dart:convert';

SubmitClaimRequest submitClaimRequestFromJson(String str) =>
    SubmitClaimRequest.fromJson(json.decode(str));

String submitClaimRequestToJson(SubmitClaimRequest data) =>
    json.encode(data.toJson());

class SubmitClaimRequest {
  SubmitClaimRequest({
    this.idUser,
    this.tanggalClaim,
    this.nominal,
    this.keterangan,
  });

  String? idUser;
  String? tanggalClaim;
  String? nominal;
  String? keterangan;

  factory SubmitClaimRequest.fromJson(Map<String, dynamic> json) =>
      SubmitClaimRequest(
        idUser: (json['user_id'] ?? json['id_user'])?.toString(),
        tanggalClaim: (json['tgl_claim'] ?? json['tanggal_claim'])?.toString(),
        nominal: (json['nominal'] ?? json['amount'])?.toString(),
        keterangan: (json['keterangan'] ?? json['note'])?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'user_id': idUser,
        'tgl_claim': tanggalClaim,
        'nominal': nominal,
        'keterangan': keterangan,
      };
}

