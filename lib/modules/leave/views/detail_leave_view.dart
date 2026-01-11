import 'package:staffku/modules/leave/controllers/leave_detail_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/shared/widgets/approval.dart';

class LeaveDetailView extends GetView<LeaveDetailController> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(title: 'Detail Izin'),
      body: Obx(() {
        final detail = controller.detail.value;
        if (detail.kodeIjin == null) {
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
                (detail.statusIjin ?? controller.statusApproval.value).toString(),
                (detail.levelApproval ?? '').toString(),
              ),
              const SizedBox(height: 12),
              const DetailSectionTitle(title: 'Informasi'),
              const SizedBox(height: 8),
              DetailSectionCard(
                child: Column(
                  children: [
                    DetailInfoRow(
                      icon: Icons.badge_outlined,
                      label: 'Nomor izin',
                      value: (detail.kodeIjin ?? '').toString(),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Tanggal mulai',
                      value: detail.dateIn == null
                          ? '-'
                          : dateFormat.format(detail.dateIn!),
                    ),
                    const SizedBox(height: 12),
                    DetailInfoRow(
                      icon: Icons.event_outlined,
                      label: 'Tanggal selesai',
                      value: detail.dateOut == null
                          ? '-'
                          : dateFormat.format(detail.dateOut!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const DetailSectionTitle(title: 'Keterangan'),
              const SizedBox(height: 8),
              DetailSectionCard(
                child: Text(
                  (detail.keterangan ?? '').toString().trim().isEmpty
                      ? '-'
                      : (detail.keterangan ?? '').toString().trim(),
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
