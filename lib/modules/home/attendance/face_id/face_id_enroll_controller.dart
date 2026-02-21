import 'dart:convert';
import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/api/api.dart';
import 'package:staffku/models/request/face/save_face_request.dart';
import 'package:staffku/shared/services/face_biometrics/face_biometrics_service.dart';

class FaceIdEnrollController extends GetxController {
  FaceIdEnrollController({
    required this.userId,
    FaceBiometricsService? faceBiometrics,
    ApiRepository? apiRepository,
  }) : _faceBiometrics = faceBiometrics ?? Get.find<FaceBiometricsService>() {
    _apiRepository = apiRepository ?? Get.find<ApiRepository>();
    faceCameraController = FaceCameraController(
      autoCapture: false,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        faceCameraCapture.value = image ?? File('');
      },
      onFaceDetected: (_) {},
    );
  }

  final String userId;
  final FaceBiometricsService _faceBiometrics;
  late final ApiRepository _apiRepository;

  final Rx<File> faceCameraCapture = Rx<File>(File(''));
  late final FaceCameraController faceCameraController;

  final RxInt stepIndex = 0.obs;
  final RxInt totalSteps = 4.obs;

  final List<File> _samples = [];
  List<double>? _savedTemplate;

  static const int _enrollmentSteps = 3;
  static const String _minimumSelfCheckSimilarityRaw = String.fromEnvironment(
    'FACE_ENROLL_SELF_CHECK_SIMILARITY',
    defaultValue: '',
  );
  static final double _minimumSelfCheckSimilarity =
      _parseOptionalSelfCheckThreshold(
    _minimumSelfCheckSimilarityRaw,
    fallback: 0.80,
  );

  bool get _isSelfCheckStep => _savedTemplate != null;

  String get stepTitle {
    final step = stepIndex.value;
    if (step == 0) return 'Hadap depan';
    if (step == 1) return 'Sedikit ke kiri';
    if (step == 2) return 'Sedikit ke kanan';
    if (step == 3) return 'Verifikasi akhir';
    return 'Posisikan wajah';
  }

  Future<void> submit(String _) async {
    final file = faceCameraCapture.value;
    if (file.path.isEmpty) {
      EasyLoading.showError('Foto belum tersedia');
      return;
    }

    try {
      EasyLoading.show(status: 'Memproses wajah...');
      final embedding = await _faceBiometrics.embeddingFromFile(file);
      if (!_isValidTemplate(embedding)) {
        EasyLoading.dismiss();
        EasyLoading.showError(
          'Sampel wajah tidak valid. Pastikan wajah terlihat jelas.',
        );
        return;
      }

      if (_isSelfCheckStep) {
        final template = _savedTemplate!;
        final score = FaceBiometricsService.cosineSimilarity(
          template,
          embedding,
        );
        if (kDebugMode) {
          print(
            '[FACE_ENROLL] self-check score=${score.toStringAsFixed(4)}, threshold=${_minimumSelfCheckSimilarity.toStringAsFixed(4)}',
          );
        }
        EasyLoading.dismiss();
        if (score < _minimumSelfCheckSimilarity) {
          EasyLoading.showError(
            'Verifikasi akhir belum cocok. Ambil ulang foto dengan posisi lurus.',
          );
          faceCameraCapture.value = File('');
          await faceCameraController.startImageStream();
          return;
        }

        EasyLoading.showSuccess('Face ID siap digunakan');
        Get.back(result: true);
        return;
      }

      _samples.add(file);

      if (_samples.length >= _enrollmentSteps) {
        final template =
            await _faceBiometrics.createTemplate(samples: _samples);
        if (!_isValidTemplate(template)) {
          EasyLoading.dismiss();
          EasyLoading.showError(
              'Template Face ID tidak valid. Coba ulangi pendaftaran.');
          return;
        }
        final res = await _apiRepository.saveFace(
          SaveFaceRequest(idUser: userId, faceId: jsonEncode(template)),
        );
        if (res == null || res.error != false) {
          EasyLoading.dismiss();
          EasyLoading.showError(res?.message ?? 'Gagal menyimpan Face ID');
          return;
        }

        _savedTemplate = template;
        stepIndex.value = _enrollmentSteps;
        faceCameraCapture.value = File('');
        EasyLoading.dismiss();
        EasyLoading.showSuccess(
          'Face ID tersimpan. Ambil 1 foto lagi untuk verifikasi akhir.',
        );
        await faceCameraController.startImageStream();
        return;
      }

      stepIndex.value = _samples.length;
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Oke, lanjut langkah berikutnya');

      faceCameraCapture.value = File('');
      await faceCameraController.startImageStream();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(
          e is FaceBiometricsException ? e.message : 'Gagal memproses wajah');
    }
  }

  bool _isValidTemplate(List<double> template) {
    if (template.length < 64) return false;
    if (template.any((x) => x.isNaN || x.isInfinite)) return false;
    final magnitude = template.fold<double>(0.0, (sum, x) => sum + (x * x));
    return magnitude > 0.0;
  }

  static double _parseOptionalSelfCheckThreshold(
    String raw, {
    required double fallback,
  }) {
    final normalized = raw.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return fallback;
    final parsed = double.tryParse(normalized);
    if (parsed == null) return fallback;
    return parsed.clamp(0.55, 0.95).toDouble();
  }
}
