import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/modules/home/base_controller.dart';

class FaceRecognitionController extends BaseController {
  FaceRecognitionController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  Rx<File>? faceCameraCapture = Rx<File>(File(""));
  RxBool isFaceDetected = false.obs;

  late FaceCameraController faceCameraController;

  @override
  void onInit() async {
    super.onInit();
    initCamera();
    faceCameraController = FaceCameraController(
      autoCapture: false,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        if (isFaceDetected.value == true) {
          faceCameraCapture?.value = image ?? File('');
        } else {
          EasyLoading.showError('Wajah tidak ditemukan');
        }
      },
      onFaceDetected: (Face? face) {
        isFaceDetected.value = true;
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> initCamera() async {
    await FaceCamera.initialize();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
