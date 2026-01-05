import 'package:get/get.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/shared/services/face_recognition/face_recognition_controller.dart';

class FaceRecognitionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceRecognitionController>(
      () => FaceRecognitionController(apiRepository: Get.find<ApiRepository>()),
    );
  }
}
