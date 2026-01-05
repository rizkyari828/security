import 'package:get/get.dart';
import 'package:staffku/modules/kuisioner/controllers/input_data_kuisioner_controller.dart';
import 'package:staffku/modules/kuisioner/controllers/kuisioner_controller.dart';

class KusionerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KusionerController>(
      () => KusionerController(apiRepository: Get.find()),
    );
    Get.lazyPut<InputDataKuisionerController>(
      () => InputDataKuisionerController(apiRepository: Get.find()),
    );
  }
}
