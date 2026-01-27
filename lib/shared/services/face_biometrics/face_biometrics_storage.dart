import 'dart:convert';
import 'dart:typed_data';

import 'package:get_storage/get_storage.dart';

class FaceBiometricsStorage {
  FaceBiometricsStorage({GetStorage? storage}) : _storage = storage ?? GetStorage();

  final GetStorage _storage;

  bool hasTemplate({required String userId}) {
    return _storage.hasData(_templateKey(userId));
  }

  FaceTemplate? readTemplate({required String userId}) {
    final b64 = _storage.read<String>(_templateKey(userId));
    final dim = _storage.read<int>(_dimKey(userId));
    if (b64 == null || dim == null) return null;

    final bytes = base64Decode(b64);
    if (bytes.lengthInBytes != dim * 4) return null;

    final floatList = Float32List.view(bytes.buffer, bytes.offsetInBytes, dim);
    return FaceTemplate(embedding: floatList.toList(growable: false));
  }

  Future<void> writeTemplate({
    required String userId,
    required List<double> embedding,
  }) async {
    final floatList = Float32List.fromList(embedding);
    final b64 = base64Encode(floatList.buffer.asUint8List());
    await _storage.write(_templateKey(userId), b64);
    await _storage.write(_dimKey(userId), embedding.length);
  }

  Future<void> deleteTemplate({required String userId}) async {
    await _storage.remove(_templateKey(userId));
    await _storage.remove(_dimKey(userId));
  }

  static String _templateKey(String userId) => 'face_bio.template.v1.$userId';
  static String _dimKey(String userId) => 'face_bio.template_dim.v1.$userId';
}

class FaceTemplate {
  const FaceTemplate({required this.embedding});

  final List<double> embedding;
}

