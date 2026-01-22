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

    String clean(String? value) {
      final text = (value ?? '').toString().trim();
      if (text.isEmpty) return '-';
      if (text.toLowerCase() == 'null') return '-';
      return text;
    }

    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'Detail Tukar Shift'),
      body: Obx(() {
        final detail = controller.detail.value;
        if (controller.isLoading.value && detail == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: ColorConstants.mainColor,
            ),
          );
        }

        if (detail == null) {
          return Center(
            child: Text(
              'Data tidak ditemukan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: 0.65),
              ),
            ),
          );
        }

        final status = (controller.statusApproval.value).toLowerCase().trim();
        final canApprove = status == 'pengajuan' ||
            status == 'proses' ||
            status == 'waiting' ||
            status == 'waiting for approval' ||
            status == 'pending' ||
            status == 'menunggu' ||
            status == 'menunggu persetujuan' ||
            status == 'diproses';
        final showApproval = controller.groupId.value != '1' &&
            controller.approvalCondition.value == true &&
            canApprove;

        final displayStatus = controller.status.value.trim().isNotEmpty
            ? controller.status.value
            : controller.statusApproval.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ApprovalFlow.statusApproval(
                displayStatus,
                '',
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
                      value: clean(controller.nama.value),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal tukar',
                      value: detail.tglTukar == null
                          ? '-'
                          : dateFormat.format(detail.tglTukar!),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Shift sebelum',
                      value: clean(detail.shiftBefore),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.swap_horiz_rounded,
                      label: 'Shift sesudah',
                      value: clean(detail.shiftAfter),
                    ),
                  ],
                ),
              ),
              if (clean(detail.note) != '-') ...[
                const SizedBox(height: 12),
                const DetailSectionTitle(title: 'Catatan'),
                const SizedBox(height: 8),
                DetailSectionCard(
                  child: Text(
                    clean(detail.note),
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
              if (clean(detail.noteTolak) != '-') ...[
                const SizedBox(height: 12),
                const DetailSectionTitle(title: 'Catatan Approval'),
                const SizedBox(height: 8),
                DetailSectionCard(
                  child: Text(
                    clean(detail.noteTolak),
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
