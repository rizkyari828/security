import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/modules/claim/controllers/claim_detail_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/common_widget.dart';

class ClaimDetailView extends GetView<ClaimDetailController> {
  const ClaimDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidget.appBar(title: 'Detail Claim'),
      body: Obx(() {
        final item = controller.detail.value;
        if (controller.isLoading.value && item == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (item == null) {
          return const Center(child: Text('Data claim tidak tersedia'));
        }

        final status = (item.status ?? '').trim();
        final photoUrl = (item.fotoUrl ?? '').trim();
        final note = (item.note ?? '').trim();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _statusPill(status),
                    const Spacer(),
                    if (controller.isLoading.value)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (photoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: photoUrl,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 230,
                        color: ColorConstants.backgroundTextField,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 230,
                        color: ColorConstants.backgroundTextField,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.black.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ColorConstants.backgroundTextField,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorConstants.borderColor),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: Colors.black.withValues(alpha: 0.45),
                    ),
                  ),
                const SizedBox(height: 18),
                _infoCard(
                  label: 'Tanggal',
                  value: _formatDateTime(item.tanggal),
                ),
                const SizedBox(height: 10),
                _infoCard(
                  label: 'Nominal',
                  value: _formatCurrency(item.nominal),
                ),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _infoCard(label: 'Catatan', value: note),
                ],
                const SizedBox(height: 18),
                CommonWidget.bodyText(text: 'Keterangan'),
                const SizedBox(height: 8),
                Text(
                  (item.keterangan ?? '').trim().isEmpty
                      ? '-'
                      : (item.keterangan ?? '').trim(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withValues(alpha: 0.78),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _infoCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorConstants.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.black.withValues(alpha: 0.78),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: 0.72),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String status) {
    final normalized = status.trim().toLowerCase();
    final isApproved = normalized == 'approved' ||
        normalized == 'approve' ||
        normalized == 'ok';
    final isPending = normalized == 'new' || normalized == 'pending';

    final bg = isApproved
        ? const Color(0xFFE7F7EE)
        : isPending
            ? const Color(0xFFFFF3E6)
            : const Color(0xFFFDECEC);
    final fg = isApproved
        ? const Color(0xFF1B7F3B)
        : isPending
            ? const Color(0xFFB54708)
            : const Color(0xFFB42318);
    final icon = isApproved
        ? Icons.check_circle_outline_rounded
        : isPending
            ? Icons.access_time_rounded
            : Icons.cancel_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
          Text(
            status.isEmpty ? '-' : status,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: fg,
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
