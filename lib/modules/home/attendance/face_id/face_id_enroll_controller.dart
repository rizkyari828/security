import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/services/face_biometrics/face_biometrics_service.dart';

class FaceIdEnrollController extends GetxController {
  FaceIdEnrollController({
    required this.userId,
    FaceBiometricsService? faceBiometrics,
  }) : _faceBiometrics = faceBiometrics ?? Get.find<FaceBiometricsService>() {
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

  final Rx<File> faceCameraCapture = Rx<File>(File(''));
  late final FaceCameraController faceCameraController;

  final RxInt stepIndex = 0.obs;
  final RxInt totalSteps = 3.obs;

  final List<File> _samples = [];

  String get stepTitle {
    final step = stepIndex.value;
    if (step == 0) return 'Hadap depan';
    if (step == 1) return 'Sedikit ke kiri';
    if (step == 2) return 'Sedikit ke kanan';
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
      await _faceBiometrics.embeddingFromFile(file);
      _samples.add(file);

      if (_samples.length >= totalSteps.value) {
        await _faceBiometrics.enroll(userId: userId, samples: _samples);
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Face ID tersimpan');
        Get.back(result: true);
        return;
      }

      stepIndex.value = _samples.length;
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Oke, lanjut langkah berikutnya');

      faceCameraCapture.value = File('');
      await faceCameraController.startImageStream();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e is FaceBiometricsException ? e.message : 'Gagal memproses wajah');
    }
  }
}
