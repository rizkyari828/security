import 'package:get/get.dart';
import 'package:sales/modules/claim/controllers/claim_controller.dart';
import 'package:sales/modules/claim/controllers/claim_detail_controller.dart';
import 'package:sales/modules/claim/controllers/claim_list_controller.dart';

class ClaimBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClaimController>(
      () => ClaimController(apiRepository: Get.find()),
    );

    Get.lazyPut<ClaimListController>(
      () => ClaimListController(apiRepository: Get.find()),
    );

    Get.lazyPut<ClaimDetailController>(
      () => ClaimDetailController(apiRepository: Get.find()),
    );
  }
}

