import 'package:staffku/api/api.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/services/face_biometrics/face_biometrics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:staffku/shared/shared.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(ApiProvider(), permanent: true);
    Get.put(ApiRepository(apiProvider: Get.find()), permanent: true);
    Get.put(FaceBiometricsService(), permanent: true);

    Get.put(
      FcmTokenService(
        apiRepository: Get.find<ApiRepository>(),
        prefs: Get.find<SharedPreferences>(),
      ),
      permanent: true,
    );

    Get.put(FcmNotificationService(), permanent: true);
  }
}
