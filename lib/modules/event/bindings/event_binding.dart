import 'package:staffku/modules/event/controllers/event_detail_controller.dart';
import 'package:get/get.dart';

import '../controllers/event_controller.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(
      () => EventController(apiRepository: Get.find()),
    );

    Get.lazyPut<ReliverDetailController>(
      () => ReliverDetailController(apiRepository: Get.find()),
    );
  }
}
