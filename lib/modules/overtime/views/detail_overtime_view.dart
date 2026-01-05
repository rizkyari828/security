import 'package:staffku/modules/overtime/controllers/overtime_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/widgets/approval.dart';

class OvertimeDetailView extends GetView<OvertimeDetailController> {
  final data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Lembur'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => controller.detail.value.idLembur == null
                ? CircularProgressIndicator(
                    backgroundColor: ColorConstants.mainColor,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ApprovalFlow.statusApproval(
                        controller.detail.value.statusLembur,
                        controller.detail.value.levelApproval,
                      ),
                      SizedBox(height: 20.0),
                      CommonWidget.labelExpanded(
                        label: 'Username',
                        value: controller.detail.value.user.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Jam Mulai',
                        value: controller.detail.value.jamIn.toString(),
                      ),
                      SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Jam Selesai',
                        value: controller.detail.value.jamOut.toString(),
                      ),
                      SizedBox(height: 20.0),
                      CommonWidget.bodyText(text: "Keterangan"),
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
