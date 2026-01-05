import 'package:staffku/models/request/attendance/attendance_wrapper.dart';

class NonScheduleSubmitRequest {
  final String? latitude;
  final String? longitude;
  final String? idUser;
  final List<PhotoAttachment>? photos;
  // NON
  final String? name;
  final String? alamat;
  final String? agenda;
  final String? status;
  final String? visitNote;
  final String? planExecution;

  NonScheduleSubmitRequest({
    this.latitude,
    this.longitude,
    this.idUser,
    this.photos,
    // NON
    this.name,
    this.alamat,
    this.agenda,
    this.status,
    this.visitNote,
    this.planExecution,
  });

  Map<String, dynamic> toJson({String? date}) => {
    'lat': latitude,
    'long': longitude,
    'id_user': idUser,
    'foto': photos?.map((e) => e.toJson()).toList(),
    'nama_kunjungan': name,
    'alamat_kunjungan': alamat,
    'status1': agenda,
    'status2': status,
    'catatan': visitNote,
    'rencana': planExecution,
  };

  factory NonScheduleSubmitRequest.fromJson(Map<String, dynamic> json) =>
      NonScheduleSubmitRequest(
        latitude: json['lat']?.toString() ?? '',
        longitude: json['long']?.toString() ?? '',
        idUser: json['id_user']?.toString() ?? '',
        photos: (json['foto'] as List? ?? [])
            .map((e) => PhotoAttachment.fromJson(e))
            .toList(),
        name: json['nama_kunjungan']?.toString() ?? '',
        alamat: json['alamat_kunjungan']?.toString() ?? '',
        agenda: json['status1']?.toString() ?? '',
        status: json['status2']?.toString() ?? '',
        visitNote: json['catatan']?.toString() ?? '',
        planExecution: json['rencana']?.toString() ?? '',
      );
}
