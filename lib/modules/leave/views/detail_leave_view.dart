import 'package:staffku/modules/leave/controllers/leave_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaveDetailView extends GetView<LeaveDetailController> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Izin'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => controller.detail.value.kodeIjin == null
                ? CircularProgressIndicator(
                    backgroundColor: ColorConstants.mainColor,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonWidget.labelExpanded(
                        label: 'Nomor Leave',
                        value: controller.detail.value.kodeIjin,
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Tanggal Mulai',
                        value: controller.detail.value.dateIn.toString() != ''
                            ? DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                  .format(
                                    controller.detail.value.dateIn ??
                                        DateTime.now(),
                                  )
                                  .toString()
                            : "",
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Tanggal Selesai',
                        value: controller.detail.value.dateOut.toString() != ''
                            ? DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                  .format(
                                    controller.detail.value.dateOut ??
                                        DateTime.now(),
                                  )
                                  .toString()
                            : "",
                      ),
                      SizedBox(height: 20.0),
                      CommonWidget.bodyText(text: "Keterangan"),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(
                        text: controller.detail.value.keterangan ?? '',
                      ),
                      SizedBox(height: 20.0),
                      // controller.tipeUser.value == '1'
                      //     ? Column(
                      //         children: [
                      //           SizedBox(height: 50.0),
                      //           Obx(() => ApprovalFlow.buttonApproval(
                      //               controller, "1", "1")),
                      //         ],
                      //       )
                      //     : Container(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
