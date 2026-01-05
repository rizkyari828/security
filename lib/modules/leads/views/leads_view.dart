import 'package:staffku/modules/leads/controllers/leads_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LeadsView extends GetView<LeadsListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'List Leads',
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

  SmartRefresher _getItems(LeadsListController controller) {
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
            controller.goToDetailPages(dataLead: controller.list[i]);
          },
          child: CommonWidget.customStatusCard(
            firstParagraf: controller.list[i].nama ?? '',
            secondParagraf: 'Email',
            secondParagrafValue: controller.list[i].email ?? '',
            thirdParagraf: 'No Telepon',
            thirdParagrafValue: controller.list[i].telphone ?? '',
            status: controller.list[i].statusLead ?? '',
            typeStatus: 'lead',
          ),
        ),
      ),
    );
  }
}
