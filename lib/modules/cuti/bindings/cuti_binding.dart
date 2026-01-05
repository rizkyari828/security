import 'package:get/get.dart';
import 'package:staffku/modules/cuti/controllers/cuti_controller.dart';
import 'package:staffku/modules/cuti/controllers/cuti_detail_controller.dart';
import 'package:staffku/modules/cuti/controllers/cuti_list_controller.dart';

class CutiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CutiController>(
      () => CutiController(apiRepository: Get.find()),
    );

    Get.lazyPut<CutiListController>(
      () => CutiListController(apiRepository: Get.find()),
    );

    Get.lazyPut<CutiDetailController>(
      () => CutiDetailController(apiRepository: Get.find()),
    );
  }
}
