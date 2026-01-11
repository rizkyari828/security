import 'package:get/get.dart';
import 'package:staffku/modules/store/controllers/result_kunjungan_controller.dart';
import 'package:staffku/modules/store/controllers/store_detail_controller.dart';
import 'package:staffku/modules/store/controllers/store_list_controller.dart';

import '../controllers/store_controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreController>(
      () => StoreController(apiRepository: Get.find()),
    );

    Get.lazyPut<StoreListController>(
      () => StoreListController(apiRepository: Get.find()),
    );

    Get.lazyPut<StoreDetailController>(
      () => StoreDetailController(apiRepository: Get.find()),
    );

    Get.lazyPut<ResultKunjunganController>(
      () => ResultKunjunganController(apiRepository: Get.find()),
    );
  }
}
