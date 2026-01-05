import 'package:staffku/modules/overtime/controllers/overtime_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/custom_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OvertimeView extends GetView<OvertimeListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'List Lembur',
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

  SmartRefresher _getItems(OvertimeListController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listLembur.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () {
            controller.goToDetailPages(
              id: controller.listLembur[i].idLembur.toString(),
            );
          },
          child: CustomExpandedCardView(
            name: controller.listLembur[i].user.toString(),
            firstParagraf:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listLembur[i].tanggalLembur ?? DateTime.now())}',
            secondParagrafLabel: "Mulai",
            secondParagrafValue: controller.listLembur[i].jamIn ?? '',
            thirdParagrafLabel: "Selesai",
            thirdParagrafValue: controller.listLembur[i].jamOut ?? '',
            approval: controller.listLembur[i].statusLembur ?? '',
            levelApproval: controller.listLembur[i].levelApproval ?? '',
          ),
        ),
      ),
    );
  }
}
