import 'package:get/get.dart';
import 'package:staffku/modules/leave/controllers/leave_detail_controller.dart';
import 'package:staffku/modules/leave/controllers/leave_list_controller.dart';

import '../controllers/leave_controller.dart';

class LeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveController>(
      () => LeaveController(apiRepository: Get.find()),
    );

    Get.lazyPut<LeaveListController>(
      () => LeaveListController(apiRepository: Get.find()),
    );

    Get.lazyPut<LeaveDetailController>(
      () => LeaveDetailController(apiRepository: Get.find()),
    );
  }
}
