import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/modules/shift_swap/controllers/shift_swap_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/approval.dart';
import 'package:staffku/shared/widgets/custom_card.dart';

class ShiftSwapView extends GetView<ShiftSwapListController> {
  const ShiftSwapView({super.key});

  String _codeFromId(int? id) {
    if (id == null) return '-';
    return 'TS${id.toString().padLeft(6, '0')}';
  }

  String _statusLabel(String? status) {
    final normalized = (status ?? '').toLowerCase().trim();

    final isPending = normalized.contains('menunggu') ||
        normalized.contains('waiting') ||
        normalized.contains('pending') ||
        normalized.contains('proses') ||
        normalized.contains('diproses');
    if (isPending) return 'Waiting';

    final isRejected = normalized.contains('tolak') || normalized.contains('reject');
    if (isRejected) return 'Rejected';

    final isApproved = normalized == 'disetujui' ||
        normalized.startsWith('disetujui ') ||
        normalized == 'approved' ||
        normalized == 'approve' ||
        normalized == 'ok';
    if (isApproved) return 'Approved';

    if (normalized.isEmpty || normalized == '-' || normalized == 'null') {
      return 'Waiting';
    }

    return status.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstants.black),
        centerTitle: false,
        title: const Text(
          'List Tukar Shift',
          style: TextStyle(
            color: ColorConstants.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          Obx(
            () => ApprovalFlow.addButtonApproval(
              controller: controller,
              onPressed: controller.goToAddPages,
              showId: '1',
            ),
          ),
        ],
      ),
      body: Obx(() => _body(controller)),
    );
  }

  Widget _body(ShiftSwapListController controller) {
    if (controller.isLoading.value && controller.listShift.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: ColorConstants.mainColor,
        ),
      );
    }

    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: const WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      child: controller.listShift.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        size: 44,
                        color: Colors.black.withValues(alpha: 0.25),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Belum ada pengajuan tukar shift.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: controller.listShift.length,
              itemBuilder: (context, i) {
                final item = controller.listShift[i];
                return InkWell(
                  onTap: () => controller.goToDetailPages(item: item),
                  child: CustomExpandedCardView(
                    name: item.tglTukar == null
                        ? '-'
                        : DateFormat(
                            'EEEE, d MMMM yyyy',
                            'id_ID',
                          ).format(item.tglTukar!),
                    firstParagraf: _codeFromId(item.id),
                    secondParagrafLabel: 'Sebelum',
                    secondParagrafValue: item.shiftBefore ?? '-',
                    thirdParagrafLabel: 'Sesudah',
                    thirdParagrafValue: item.shiftAfter ?? '-',
                    forthParagraf: '',
                    approval: _statusLabel(item.status),
                  ),
                );
              },
            ),
    );
  }
}
