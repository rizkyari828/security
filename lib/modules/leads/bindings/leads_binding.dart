import 'package:get/get.dart';
import 'package:staffku/modules/leads/controllers/leads_controller.dart';
import 'package:staffku/modules/leads/controllers/leads_detail_controller.dart';
import 'package:staffku/modules/leads/controllers/leads_list_controller.dart';

class LeadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeadsController>(
      () => LeadsController(apiRepository: Get.find()),
    );

    Get.lazyPut<LeadsListController>(
      () => LeadsListController(apiRepository: Get.find()),
    );

    Get.lazyPut<LeadsDetailController>(
      () => LeadsDetailController(apiRepository: Get.find()),
    );
  }
}
