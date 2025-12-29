import 'dart:typed_data';

class PayslipDownloadResult {
  PayslipDownloadResult({
    required this.bytes,
    this.filename,
    this.mimeType,
  });

  final Uint8List bytes;
  final String? filename;
  final String? mimeType;
}

