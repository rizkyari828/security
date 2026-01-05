import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/modules/claim/controllers/claim_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/custom_card.dart';

class ClaimView extends GetView<ClaimListController> {
  const ClaimView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstants.black),
        centerTitle: false,
        title: const Text(
          'List Claim',
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

  SmartRefresher _getItems(ClaimListController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listClaim.length,
        itemBuilder: (context, i) {
          final item = controller.listClaim[i];
          return InkWell(
            onTap: () =>
                controller.goToDetailPages(id: item.idClaim?.toString() ?? ''),
            child: CustomExpandedCardView(
              name: item.user ?? '',
              firstParagraf:
                  '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(item.tanggalClaim ?? DateTime.now())}',
              secondParagrafLabel: 'Nominal',
              secondParagrafValue: item.nominal ?? '-',
              approval: item.statusClaim ?? '',
              levelApproval: item.levelApproval ?? '',
            ),
          );
        },
      ),
    );
  }
}
