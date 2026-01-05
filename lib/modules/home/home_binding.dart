import 'package:staffku/modules/home/attendance/attendance_controller.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(apiRepository: Get.find()),
    );
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(apiRepository: Get.find()),
    );
  }
}
