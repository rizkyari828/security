import 'package:intl/intl.dart';
import 'package:staffku/modules/agent/controllers/agent_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AgentView extends GetView<AgentListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'List Agent',
          style: TextStyle(
            color: ColorConstants.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          Obx(
            () => ApprovalFlow.addButtonApproval(
              controller: controller,
              onPressed: controller.goToAddPages,
            ),
          ),
        ],
      ),
      body: Obx(() => _getItems(controller)),
    );
  }

  SmartRefresher _getItems(AgentListController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.list.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () {
            controller.goToDetailPages(dataAgent: controller.list[i]);
          },
          child: CustomExpandedCardView(
            name: controller.list[i].fullName ?? '',
            firstParagraf: controller.list[i].email ?? '',
            secondParagrafLabel: "Tanggal Bergabung",
            secondParagrafValue:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.list[i].joinDate ?? DateTime.now())}',
            thirdParagrafLabel: "Penempatan",
            thirdParagrafValue: controller.list[i].placement ?? '',
          ),
        ),
      ),
    );
  }
}
