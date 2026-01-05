import 'package:get/get.dart';
import 'package:staffku/modules/input/controllers/input_controller.dart';

class InputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputController>(
      () => InputController(apiRepository: Get.find()),
    );
  }
}
