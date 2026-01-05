import 'package:staffku/modules/home/attendance/attendance_controller.dart';
import 'package:get/get.dart';

class AttendanceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceController>(
      () => AttendanceController(apiRepository: Get.find()),
    );
  }
}
