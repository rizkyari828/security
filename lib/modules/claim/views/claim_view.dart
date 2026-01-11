import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/modules/claim/controllers/claim_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/custom_card.dart';

class ClaimView extends GetView<ClaimListController> {
  const ClaimView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorConstants.black),
        centerTitle: false,
        title: const Text(
          'Claim Asuransi',
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
          IconButton(
            onPressed: controller.goToAddPages,
            tooltip: 'Ajukan claim',
            icon: const Icon(Icons.add_box_rounded),
          ),
        ],
      ),
      body: Obx(() => _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    if (controller.isLoading.value && controller.listClaim.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return _getItems(context);
  }

  SmartRefresher _getItems(BuildContext context) {
    final isEmpty = controller.listClaim.isEmpty;
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: const WaterDropHeader(),
      controller: controller.refreshController,
      onRefresh: controller.onRefresh,
      onLoading: controller.onLoading,
      child: ListView.builder(
        itemCount: isEmpty ? 2 : controller.listClaim.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _summaryHeader(context);
          }

          if (isEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColorConstants.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Belum ada pengajuan claim',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ajukan claim asuransi untuk proses pencairan. Pastikan nominal dan bukti foto sudah benar.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withValues(alpha: 0.68),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: controller.goToAddPages,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Ajukan Claim'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.mainColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final item = controller.listClaim[index - 1];
          return InkWell(
            onTap: () =>
                controller.goToDetailPages(id: item.id?.toString() ?? ''),
            child: CustomExpandedCardView(
              firstParagraf: item.keterangan ?? 'Claim',
              name: _formatDateTime(item.tanggal),
              secondParagrafLabel: 'Nominal',
              secondParagrafValue: _formatCurrency(item.nominal),
              thirdParagrafLabel:
                  (item.note ?? '').trim().isEmpty ? '' : 'Catatan',
              thirdParagrafValue: (item.note ?? '').trim(),
              approval: (item.status ?? '').trim(),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorConstants.mainColor, ColorConstants.secondaryColor],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ringkasan Klaim',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pantau plafon asuransi, penggunaan, dan sisa yang dapat dicairkan.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.86),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _summaryItem(
                      label: 'Plafon',
                      value: _formatCurrency(controller.nominalPlafon.value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _summaryItem(
                      label: 'Terpakai',
                      value: _formatCurrency(controller.terpakaiPlafon.value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _summaryItem(
                      label: 'Sisa',
                      value: _formatCurrency(controller.sisaPlafon.value),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryItem({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int? value) {
    final val = value ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(val);
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return '-';
    return DateFormat("EEEE, d MMMM yyyy • HH:mm", "id_ID").format(date);
  }
}
