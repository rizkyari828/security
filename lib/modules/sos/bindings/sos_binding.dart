import 'package:get/get.dart';
import 'package:staffku/modules/sos/controllers/sos_detail_controller.dart';
import 'package:staffku/modules/sos/controllers/sos_form_controller.dart';
import 'package:staffku/modules/sos/controllers/sos_list_controller.dart';

class SosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SosListController>(() => SosListController(apiRepository: Get.find()));
    Get.lazyPut<SosFormController>(() => SosFormController(apiRepository: Get.find()));
    Get.lazyPut<SosDetailController>(() => SosDetailController(apiRepository: Get.find()));
  }
}

