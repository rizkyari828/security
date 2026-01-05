import 'package:staffku/modules/event/controllers/event_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventView extends GetView<EventController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'Event',
          style: TextStyle(
            color: ColorConstants.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
        elevation: 0.0,
      ),
      body: Obx(() => _getItems(controller)),
    );
  }

  SmartRefresher _getItems(EventController controller) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: controller.listEvent.length,
        itemBuilder: (context, i) => InkWell(
          onTap: () {
            controller.goToDetailPages(
              id: controller.listEvent[i].id.toString(),
            );
          },
          child: CustomExpandedImageCardView(
            title: controller.listEvent[i].namaEvent ?? '',
            date:
                '${DateFormat("MMMM dd, yyyy", "en_EN").format(controller.listEvent[i].tanggalAcara ?? DateTime.now())}',
            description: controller.listEvent[i].lokasiAcara ?? '',
            image: controller.listEvent[i].foto ?? '',
            location: controller.listEvent[i].kotaAcara ?? '',
            time:
                '${controller.listEvent[i].jamMulai} - ${controller.listEvent[i].jamSelesai}',
            // tipe: controller.listReliver[i].leaveTypeName ?? '',
          ),
        ),
      ),
    );
  }
}
