import 'package:staffku/modules/cuti/controllers/cuti_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/widgets/approval.dart';

class CutiDetailView extends GetView<CutiDetailController> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Cuti'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => controller.detail.value.idCuti == null
                ? CircularProgressIndicator(
                    backgroundColor: ColorConstants.mainColor,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ApprovalFlow.statusApproval(
                        controller.detail.value.statusCuti,
                        controller.detail.value.levelApproval,
                      ),
                      SizedBox(height: 20.0),
                      CommonWidget.labelExpanded(
                        label: 'Usename',
                        value: controller.detail.value.user.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Tanggal Mulai',
                        value: controller.detail.value.tanggalAwal.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Tanggal Selesai',
                        value: controller.detail.value.tanggalAkhir.toString(),
                      ),
                      SizedBox(height: 20.0),
                      CommonWidget.bodyText(text: "Keperluan"),
                      SizedBox(height: 10.0),
                      CommonWidget.bodyText(
                        text: controller.detail.value.keperluan ?? '',
                      ),
                      SizedBox(height: 20.0),
                      Obx(() => ApprovalFlow.buttonApproval(controller)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
