class SosReport {
  final int id;
  final String keterangan;
  final String photoPath;
  final DateTime createdAt;

  const SosReport({
    required this.id,
    required this.keterangan,
    required this.photoPath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'keterangan': keterangan,
        'photo_path': photoPath,
        'created_at': createdAt.toIso8601String(),
      };

  factory SosReport.fromJson(Map<String, dynamic> json) {
    return SosReport(
      id: (json['id'] as num?)?.toInt() ?? 0,
      keterangan: (json['keterangan'] as String?) ?? '',
      photoPath: (json['photo_path'] as String?) ?? '',
      createdAt: DateTime.tryParse((json['created_at'] as String?) ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}

