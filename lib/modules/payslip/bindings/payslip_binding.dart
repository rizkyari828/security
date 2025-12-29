import 'package:get/get.dart';
import 'package:sales/modules/payslip/controllers/payslip_controller.dart';

class PayslipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayslipController>(
      () => PayslipController(apiRepository: Get.find()),
    );
  }
}

