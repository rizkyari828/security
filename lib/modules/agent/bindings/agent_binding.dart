import 'package:get/get.dart';
import 'package:staffku/modules/agent/controllers/agent_controller.dart';
import 'package:staffku/modules/agent/controllers/agent_detail_controller.dart';
import 'package:staffku/modules/agent/controllers/agent_list_controller.dart';

class AgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgentController>(
      () => AgentController(apiRepository: Get.find()),
    );

    Get.lazyPut<AgentListController>(
      () => AgentListController(apiRepository: Get.find()),
    );

    Get.lazyPut<AgentDetailController>(
      () => AgentDetailController(apiRepository: Get.find()),
    );
  }
}
