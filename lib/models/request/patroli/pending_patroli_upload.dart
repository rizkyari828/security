class PendingPatroliUpload {
  PendingPatroliUpload({
    required this.idUser,
    required this.idJadwal,
    required this.keterangan,
    required this.fotoPath,
    this.createdAtIso,
  });

  final String idUser;
  final String idJadwal;
  final String keterangan;
  final String fotoPath;
  final String? createdAtIso;

  factory PendingPatroliUpload.fromJson(Map<String, dynamic> json) =>
      PendingPatroliUpload(
        idUser: json['id_user']?.toString() ?? '',
        idJadwal: json['id_jadwal']?.toString() ?? '',
        keterangan: json['keterangan']?.toString() ?? '',
        fotoPath: json['foto_path']?.toString() ?? '',
        createdAtIso: json['created_at']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
        'id_jadwal': idJadwal,
        'keterangan': keterangan,
        'foto_path': fotoPath,
        'created_at': createdAtIso,
      };
}

