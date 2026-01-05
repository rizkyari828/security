import 'package:staffku/modules/notification/controllers/notification_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationView extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorConstants.black, //change your color here
        ),
        centerTitle: false,
        title: Text(
          'Notifikasi',
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

  SmartRefresher _getItems(NotificationController controller) {
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
            controller.goToDetailCutiPages(
              id: controller.listCuti[i].id.toString(),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            // height: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(width: 2.0, color: ColorConstants.borderColor),
              // boxShadow: [
              //   BoxShadow(
              //     color: CommonWidget.setOpacity(Colors.black, 0.3),
              //     blurRadius: 20.0,
              //     spreadRadius: 4.0,
              //     offset: Offset(
              //       -10.0,
              //       10.0,
              //     ),
              //   ),
              // ],
            ),
            child: ListTile(
              title: Text(controller.listCuti[i].noTrans ?? ''),
              subtitle: Text(
                '${DateFormat("EEEE, d MMMM yyyy", "id_ID").format(controller.listCuti[i].dateBoking ?? DateTime.now())}',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
