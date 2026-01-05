import 'package:get/get.dart';
import 'package:staffku/modules/prospek/controllers/prospek_add_controller.dart';
import 'package:staffku/modules/prospek/controllers/prospek_detail_controller.dart';

import '../controllers/prospek_controller.dart';

class LemburBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProspekController>(
      () => ProspekController(apiRepository: Get.find()),
    );

    Get.lazyPut<ProspekDetailController>(
      () => ProspekDetailController(apiRepository: Get.find()),
    );

    Get.lazyPut<ProspekAddController>(
      () => ProspekAddController(apiRepository: Get.find()),
    );
  }
}
