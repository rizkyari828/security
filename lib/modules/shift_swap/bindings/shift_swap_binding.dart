import 'package:get/get.dart';
import 'package:sales/modules/shift_swap/controllers/shift_swap_controller.dart';
import 'package:sales/modules/shift_swap/controllers/shift_swap_detail_controller.dart';
import 'package:sales/modules/shift_swap/controllers/shift_swap_list_controller.dart';

class ShiftSwapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShiftSwapController>(
      () => ShiftSwapController(apiRepository: Get.find()),
    );

    Get.lazyPut<ShiftSwapListController>(
      () => ShiftSwapListController(apiRepository: Get.find()),
    );

    Get.lazyPut<ShiftSwapDetailController>(
      () => ShiftSwapDetailController(apiRepository: Get.find()),
    );
  }
}

