import 'package:sales/modules/leave/controllers/leave_list_controller.dart';
import 'package:sales/shared/constants/constants.dart';
import 'package:sales/shared/widgets/approval.dart';
import 'package:sales/shared/widgets/custom_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LeaveView extends GetView<LeaveListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'List Izin',
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

  SmartRefresher _getItems(LeaveListController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listIzin.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () {
            controller.goToDetailPages(
              id: controller.listIzin[i].id.toString(),
            );
          },
          child: CustomExpandedCardView(
            name:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listIzin[i].cDate ?? DateTime.now())}',
            firstParagraf: controller.listIzin[i].kodeIjin ?? '',
            secondParagrafLabel: "Mulai",
            secondParagrafValue:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listIzin[i].dateIn ?? DateTime.now())}',
            thirdParagrafLabel: "Selesai",
            thirdParagrafValue:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listIzin[i].dateOut ?? DateTime.now())}',
            forthParagraf: controller.listIzin[i].keterangan ?? '',
            approval: controller.tipeUser.value == '1' ? '' : 'Waiting',
            // approval:
            //     controller.listIzin[i].statusLabel == 'Waiting for approval'
            //         ? 'Waiting'
            //         : controller.listIzin[i].statusLabel ?? '',
          ),
        ),
      ),
    );
  }
}
