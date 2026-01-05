import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/modules/claim/controllers/claim_detail_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/approval.dart';

class ClaimDetailView extends GetView<ClaimDetailController> {
  const ClaimDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Claim'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Obx(
            () => controller.detail.value.idClaim == null
                ? CircularProgressIndicator(
                    backgroundColor: ColorConstants.mainColor,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ApprovalFlow.statusApproval(
                        (controller.detail.value.statusClaim ?? '').toString(),
                        (controller.detail.value.levelApproval ?? '')
                            .toString(),
                      ),
                      const SizedBox(height: 20.0),
                      CommonWidget.labelExpanded(
                        label: 'Username',
                        value: controller.detail.value.user.toString(),
                      ),
                      const SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Tanggal Claim',
                        value: DateFormat('yyyy-MM-dd', 'id_ID').format(
                          controller.detail.value.tanggalClaim ??
                              DateTime.now(),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      CommonWidget.labelExpanded(
                        label: 'Nominal',
                        value: controller.detail.value.nominal ?? '-',
                      ),
                      const SizedBox(height: 20.0),
                      CommonWidget.bodyText(text: 'Keterangan'),
                      const SizedBox(height: 10.0),
                      CommonWidget.bodyText(
                        text: controller.detail.value.keterangan ?? '',
                      ),
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
