import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:face_camera/face_camera.dart';
import 'package:image/image.dart' as img;

import 'face_biometrics_storage.dart';
import 'face_embedding_model.dart';

class FaceBiometricsService {
  FaceBiometricsService({
    FaceBiometricsStorage? storage,
    FaceEmbeddingModel? model,
  }) : _storage = storage ?? FaceBiometricsStorage(),
       _model = model ?? FaceEmbeddingModel();

  final FaceBiometricsStorage _storage;
  final FaceEmbeddingModel _model;

  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableLandmarks: true,
      enableTracking: false,
    ),
  );

  bool hasEnrollment({required String userId}) => _storage.hasTemplate(userId: userId);

  Future<void> clearEnrollment({required String userId}) async {
    await _storage.deleteTemplate(userId: userId);
  }

  Future<void> enroll({
    required String userId,
    required List<File> samples,
  }) async {
    if (samples.isEmpty) {
      throw ArgumentError('samples is empty');
    }

    final embeddings = <List<double>>[];
    for (final file in samples) {
      embeddings.add(await embeddingFromFile(file));
    }

    final template = _averageAndNormalize(embeddings);
    await _storage.writeTemplate(userId: userId, embedding: template);
  }

  Future<FaceVerifyResult> verify({
    required String userId,
    required File sample,
    double threshold = 0.60,
  }) async {
    final template = _storage.readTemplate(userId: userId);
    if (template == null) {
      return const FaceVerifyResult.notEnrolled();
    }

    final embedding = await embeddingFromFile(sample);
    final similarity = cosineSimilarity(template.embedding, embedding);
    return FaceVerifyResult(
      similarity: similarity,
      threshold: threshold,
      matched: similarity >= threshold,
    );
  }

  Future<List<double>> embeddingFromFile(File file) async {
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw StateError('Failed to decode image');
    }

    final oriented = img.bakeOrientation(decoded);
    final faceBox = await _detectLargestFaceBox(file);
    final cropped = _cropWithMargin(oriented, faceBox, marginFactor: 0.25);

    await _model.ensureLoaded();
    final resized = img.copyResize(
      cropped,
      width: _model.inputWidth,
      height: _model.inputHeight,
      interpolation: img.Interpolation.linear,
    );

    final input = _toMobileFaceNetInput(
      resized,
      width: _model.inputWidth,
      height: _model.inputHeight,
      channels: _model.inputChannels,
    );
    return _model.embed(input);
  }

  Future<FaceBox> _detectLargestFaceBox(File file) async {
    final input = InputImage.fromFilePath(file.path);
    final faces = await _detector.processImage(input);
    if (faces.isEmpty) {
      throw const FaceBiometricsException('Wajah tidak ditemukan');
    }

    Face? best;
    var bestArea = -1.0;
    for (final f in faces) {
      final b = f.boundingBox;
      final area = b.width * b.height;
      if (area > bestArea) {
        bestArea = area;
        best = f;
      }
    }

    final b = best!.boundingBox;
    return FaceBox(left: b.left, top: b.top, right: b.right, bottom: b.bottom);
  }

  img.Image _cropWithMargin(
    img.Image source,
    FaceBox faceBox, {
    required double marginFactor,
  }) {
    final w = faceBox.width.toDouble();
    final h = faceBox.height.toDouble();
    final margin = math.max(w, h) * marginFactor;

    final left = (faceBox.left - margin).floor().clamp(0, source.width - 1);
    final top = (faceBox.top - margin).floor().clamp(0, source.height - 1);
    final right = (faceBox.right + margin).ceil().clamp(1, source.width);
    final bottom = (faceBox.bottom + margin).ceil().clamp(1, source.height);

    final cropW = math.max(1, right - left);
    final cropH = math.max(1, bottom - top);
    return img.copyCrop(source, x: left, y: top, width: cropW, height: cropH);
  }

  Float32List _toMobileFaceNetInput(
    img.Image image, {
    required int width,
    required int height,
    required int channels,
  }) {
    if (channels != 3) {
      throw StateError('Expected 3-channel input, got $channels');
    }

    final input = Float32List(width * height * channels);
    var i = 0;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toDouble();
        final g = pixel.g.toDouble();
        final b = pixel.b.toDouble();

        input[i++] = (r - 127.5) / 128.0;
        input[i++] = (g - 127.5) / 128.0;
        input[i++] = (b - 127.5) / 128.0;
      }
    }
    return input;
  }

  List<double> _averageAndNormalize(List<List<double>> embeddings) {
    final dim = embeddings.first.length;
    final sum = Float64List(dim);
    for (final e in embeddings) {
      if (e.length != dim) {
        throw StateError('Embedding dimension mismatch');
      }
      for (var i = 0; i < dim; i++) {
        sum[i] += e[i];
      }
    }
    final avg = List<double>.generate(dim, (i) => sum[i] / embeddings.length);
    final norm = math.sqrt(avg.fold<double>(0.0, (p, x) => p + x * x));
    if (norm == 0.0) return avg;
    return avg.map((x) => x / norm).toList(growable: false);
  }

  static double cosineSimilarity(List<double> a, List<double> b) {
    final n = math.min(a.length, b.length);
    var dot = 0.0;
    var na = 0.0;
    var nb = 0.0;
    for (var i = 0; i < n; i++) {
      final x = a[i];
      final y = b[i];
      dot += x * y;
      na += x * x;
      nb += y * y;
    }
    if (na == 0.0 || nb == 0.0) return 0.0;
    return dot / (math.sqrt(na) * math.sqrt(nb));
  }
}

class FaceBox {
  const FaceBox({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get width => right - left;
  double get height => bottom - top;
}

class FaceVerifyResult {
  const FaceVerifyResult({
    required this.similarity,
    required this.threshold,
    required this.matched,
    this.enrolled = true,
  });

  const FaceVerifyResult.notEnrolled()
    : similarity = 0.0,
      threshold = 0.0,
      matched = false,
      enrolled = false;

  final double similarity;
  final double threshold;
  final bool matched;
  final bool enrolled;
}

class FaceBiometricsException implements Exception {
  const FaceBiometricsException(this.message);
  final String message;

  @override
  String toString() => 'FaceBiometricsException: $message';
}
