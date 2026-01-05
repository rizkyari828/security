import 'package:get/get.dart';
import 'package:staffku/modules/prospek_v2/controllers/prospek_add_controller.dart';
import '../controllers/prospek_controller.dart';

class ProspekV2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProspekV2Controller>(
      () => ProspekV2Controller(apiRepository: Get.find()),
    );

    Get.lazyPut<ProspekV2AddController>(
      () => ProspekV2AddController(apiRepository: Get.find()),
    );
  }
}
