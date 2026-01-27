import 'package:staffku/api/api.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/services/face_biometrics/face_biometrics_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(ApiProvider(), permanent: true);
    Get.put(ApiRepository(apiProvider: Get.find()), permanent: true);
    Get.put(FaceBiometricsService(), permanent: true);
  }
}
