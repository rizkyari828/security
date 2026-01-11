import 'package:staffku/modules/overtime/controllers/overtime_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/shared/widgets/approval.dart';

class OvertimeDetailView extends GetView<OvertimeDetailController> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'Detail Lembur'),
      body: Obx(() {
        final detail = controller.detail.value;
        if (detail.idLembur == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: ColorConstants.mainColor,
            ),
          );
        }

        final status = (controller.statusApproval.value).toLowerCase().trim();
        final canApprove = status == 'pengajuan' ||
            status == 'proses' ||
            status == 'waiting' ||
            status == 'waiting for approval' ||
            status == 'pending';
        final showApproval = controller.groupId.value != '1' &&
            controller.approvalCondition.value == true &&
            canApprove;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApprovalFlow.statusApproval(
                detail.statusLembur,
                detail.levelApproval,
              ),
              const SizedBox(height: 12),
              const DetailSectionTitle(title: 'Informasi'),
              const SizedBox(height: 8),
              DetailSectionCard(
                child: Column(
                  children: [
                    DetailInfoRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Username',
                      value: (detail.user ?? '').toString(),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal lembur',
                      value: detail.tanggalLembur == null
                          ? '-'
                          : dateFormat.format(detail.tanggalLembur!),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.login_rounded,
                      label: 'Jam mulai',
                      value: (detail.jamIn ?? '').toString(),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.logout_rounded,
                      label: 'Jam selesai',
                      value: (detail.jamOut ?? '').toString(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const DetailSectionTitle(title: 'Keterangan'),
              const SizedBox(height: 8),
              DetailSectionCard(
                child: Text(
                  (detail.keperluan ?? '').toString().trim().isEmpty
                      ? '-'
                      : (detail.keperluan ?? '').toString().trim(),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.black,
                    height: 1.3,
                  ),
                ),
              ),
              if (showApproval) ...[
                const SizedBox(height: 12),
                ApprovalFlow.buttonApproval(controller),
              ],
            ],
          ),
        );
      }),
    );
  }
}
