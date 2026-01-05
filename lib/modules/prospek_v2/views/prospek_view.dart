import 'package:staffku/modules/prospek_v2/controllers/prospek_controller.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/custom_pop_scope.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../shared/utils/common_widget.dart';

class ProspekV2View extends GetView<ProspekV2Controller> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onWillPop: () async {
        Get.offAllNamed(Routes.HOME);
        return false;
      },
      child: _buildWidget(context),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'List Prospek',
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

  SmartRefresher _getItems(ProspekV2Controller controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listProspek.length,
        itemBuilder: (context, i) => Column(
          children: [
            InkWell(
              onTap: () {
                if (controller.groupId.value == "1") {
                  controller.goToDetailPages(
                    dataProspect: controller.listProspek[i],
                  );
                }
              },
              child: CommonWidget.customStatusCard(
                firstParagraf: controller.listProspek[i].prospectName ?? '',
                secondParagraf: 'Nama Product',
                secondParagrafValue:
                    controller.listProspek[i].productName ?? '',
                thirdParagraf: 'Status Prospek',
                thirdParagrafValue:
                    controller.listProspek[i].statusProspectValue ?? '',
                status:
                    controller.listProspek[i].sourceOrderValue ??
                    'Belum ada Status',
                typeStatus: 'prospect',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
