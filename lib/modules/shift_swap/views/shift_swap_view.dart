import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sales/modules/shift_swap/controllers/shift_swap_list_controller.dart';
import 'package:sales/shared/constants/constants.dart';
import 'package:sales/shared/widgets/approval.dart';
import 'package:sales/shared/widgets/custom_card.dart';

class ShiftSwapView extends GetView<ShiftSwapListController> {
  const ShiftSwapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstants.black),
        centerTitle: false,
        title: const Text(
          'List Tukar Shift',
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
              showId: '1',
            ),
          ),
        ],
      ),
      body: Obx(() => _getItems(controller)),
    );
  }

  SmartRefresher _getItems(ShiftSwapListController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listShiftSwap.length,
        itemBuilder: (context, i) {
          final item = controller.listShiftSwap[i];
          return InkWell(
            onTap: () => controller.goToDetailPages(
                id: item.idTukarShift?.toString() ?? ''),
            child: CustomExpandedCardView(
              name: item.user ?? '',
              firstParagraf:
                  '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(item.tanggalTukar ?? DateTime.now())}',
              secondParagrafLabel: 'Shift',
              secondParagrafValue: item.shiftTukar ?? '-',
              thirdParagrafLabel: 'Pengganti',
              thirdParagrafValue: item.userPengganti ?? '-',
              approval: item.statusTukar ?? '',
              levelApproval: item.levelApproval ?? '',
            ),
          );
        },
      ),
    );
  }
}

