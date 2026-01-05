import 'package:staffku/modules/cuti/controllers/cuti_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/custom_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CutiView extends GetView<CutiListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'List Cuti',
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

  SmartRefresher _getItems(CutiListController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listCuti.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () {
            controller.goToDetailPages(
              id: controller.listCuti[i].idCuti.toString(),
            );
          },
          child: CustomExpandedCardView(
            name: controller.listCuti[i].user.toString(),
            firstParagraf:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listCuti[i].tanggalPengajuan ?? DateTime.now())}',
            secondParagrafLabel: "Tanggal Mulai",
            secondParagrafValue:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listCuti[i].tanggalAwal ?? DateTime.now())}',
            thirdParagrafLabel: "Tanggal Selesai",
            thirdParagrafValue:
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listCuti[i].tanggalAkhir ?? DateTime.now())}',
            approval: controller.listCuti[i].statusCuti ?? '',
            levelApproval: controller.listCuti[i].levelApproval ?? '',
          ),
        ),
      ),
    );
  }
}
