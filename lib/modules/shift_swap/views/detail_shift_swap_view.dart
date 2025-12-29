import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales/modules/shift_swap/controllers/shift_swap_detail_controller.dart';
import 'package:sales/shared/constants/constants.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/widgets/approval.dart';

class ShiftSwapDetailView extends GetView<ShiftSwapDetailController> {
  const ShiftSwapDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Tukar Shift'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => controller.detail.value.idTukarShift == null
                ? CircularProgressIndicator(
                    backgroundColor: ColorConstants.mainColor,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ApprovalFlow.statusApproval(
                        (controller.detail.value.statusTukar ?? '').toString(),
                        (controller.detail.value.levelApproval ?? '').toString(),
                      ),
                      const SizedBox(height: 20.0),
                      CommonWidget.labelExpanded(
                        label: 'Username',
                        value: controller.detail.value.user.toString(),
                      ),
                      const SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Tanggal Tukar',
                        value: DateFormat('yyyy-MM-dd', 'id_ID').format(
                          controller.detail.value.tanggalTukar ?? DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Shift Tukar',
                        value: controller.detail.value.shiftTukar ?? '-',
                      ),
                      const SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Pengganti',
                        value: controller.detail.value.userPengganti ?? '-',
                      ),
                      if ((controller.detail.value.alasan ?? '').isNotEmpty) ...[
                        const SizedBox(height: 20.0),
                        CommonWidget.bodyText(text: 'Alasan'),
                        const SizedBox(height: 10.0),
                        CommonWidget.bodyText(
                            text: controller.detail.value.alasan ?? ''),
                      ],
                      const SizedBox(height: 20.0),
                      Obx(() => ApprovalFlow.buttonApproval(controller)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

