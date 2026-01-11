import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/modules/shift_swap/controllers/shift_swap_detail_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/detail_section.dart';

class ShiftSwapDetailView extends GetView<ShiftSwapDetailController> {
  const ShiftSwapDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'Detail Tukar Shift'),
      body: Obx(() {
        final detail = controller.detail.value;
        if (detail.idTukarShift == null) {
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
                (detail.statusTukar ?? '').toString(),
                (detail.levelApproval ?? '').toString(),
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
                      label: 'Tanggal tukar',
                      value: detail.tanggalTukar == null
                          ? '-'
                          : dateFormat.format(detail.tanggalTukar!),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Shift tukar',
                      value: (detail.shiftTukar ?? '-').toString(),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'Pengganti',
                      value: (detail.userPengganti ?? '-').toString(),
                    ),
                  ],
                ),
              ),
              if ((detail.alasan ?? '').toString().trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                const DetailSectionTitle(title: 'Alasan'),
                const SizedBox(height: 8),
                DetailSectionCard(
                  child: Text(
                    (detail.alasan ?? '').toString().trim(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: ColorConstants.black,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
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
