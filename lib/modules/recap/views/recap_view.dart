import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:staffku/models/response/recap_history.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/common_widget.dart';

import '../controllers/recap_controller.dart';

class RecapView extends GetView<RecapController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightGray,
      appBar: CommonWidget.appBar(
        title: 'Rekap Kehadiran',
        centerTextAlign: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _RecapHeaderCard(onPickMonth: () => _pickMonth(context)),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.getData,
              child: controller.obx(
                (items) => _RecapList(items ?? const <DataHistory>[]),
                onLoading: const _RecapLoading(),
                onEmpty: _RecapEmpty(onPickMonth: () => _pickMonth(context)),
                onError: (message) =>
                    _RecapError(message: message, onRetry: controller.getData),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMonth(BuildContext context) async {
    final date = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1, 1),
      lastDate: DateTime(DateTime.now().year + 1, 12),
      initialDate: controller.selectedDate ?? DateTime.now(),
    );
    if (date == null) return;

    controller.selectedDate = date;
    controller.month.value = DateFormat(
      "MMMM yyyy",
      "id_ID",
    ).format(date).toString();
    await controller.getData();
  }
}

class _RecapHeaderCard extends GetView<RecapController> {
  const _RecapHeaderCard({required this.onPickMonth});

  final VoidCallback onPickMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorConstants.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Obx(() {
          final total = controller.historyData.length;
          final complete = controller.historyData.where((e) {
            final inOk = (e.absenIn ?? '').trim().isNotEmpty;
            final outOk = (e.absenOut ?? '').trim().isNotEmpty;
            return inOk && outOk;
          }).length;
          final pending = total - complete;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Absen',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.black.withValues(alpha: 0.55),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.month.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _IconActionButton(
                    tooltip: 'Pilih bulan',
                    icon: Icons.calendar_month_rounded,
                    onPressed: onPickMonth,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  const gap = 10.0;
                  final chipWidth = ((constraints.maxWidth - (gap * 2)) / 3)
                      .clamp(0.0, double.infinity);

                  return Row(
                    children: [
                      SizedBox(
                        width: chipWidth,
                        child: _StatChip(
                          icon: Icons.event_available_rounded,
                          label: 'Total',
                          value: '$total hari',
                          background: ColorConstants.blueBackground,
                          foreground: ColorConstants.mainColor,
                        ),
                      ),
                      const SizedBox(width: gap),
                      SizedBox(
                        width: chipWidth,
                        child: _StatChip(
                          icon: Icons.check_circle_rounded,
                          label: 'Lengkap',
                          value: '$complete',
                          background: const Color(0xFFE7F7EE),
                          foreground: const Color(0xFF1B7F3B),
                        ),
                      ),
                      const SizedBox(width: gap),
                      SizedBox(
                        width: chipWidth,
                        child: _StatChip(
                          icon: Icons.hourglass_bottom_rounded,
                          label: 'Belum lengkap',
                          value: '$pending',
                          background: const Color(0xFFFFF3E6),
                          foreground: const Color(0xFFB54708),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  const _IconActionButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: Ink(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: ColorConstants.mainColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Tooltip(
            message: tooltip,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.background,
    required this.foreground,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: foreground.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon, color: foreground, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: foreground.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapList extends StatelessWidget {
  const _RecapList(this.items);

  final List<DataHistory> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _RecapRowCard(item: items[index]),
    );
  }
}

class _RecapRowCard extends StatelessWidget {
  const _RecapRowCard({required this.item});

  final DataHistory item;

  @override
  Widget build(BuildContext context) {
    final date = item.tanggal ?? DateTime.now();
    final day = DateFormat('EEEE', 'id_ID').format(date);
    final dateText = DateFormat('dd MMM yyyy', 'id_ID').format(date);
    final inText = (item.absenIn ?? '').trim().isEmpty
        ? '--:--'
        : item.absenIn!.trim();
    final outText = (item.absenOut ?? '').trim().isEmpty
        ? '--:--'
        : item.absenOut!.trim();
    final isComplete = inText != '--:--' && outText != '--:--';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ColorConstants.borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorConstants.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    dateText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _TimePill(label: 'Masuk', value: inText),
                    _TimePill(label: 'Pulang', value: outText),
                  ],
                ),
                const SizedBox(height: 6),
                _StatusPillSmall(isComplete: isComplete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isEmpty = value == '--:--';
    final bg = isEmpty
        ? Colors.black.withValues(alpha: 0.04)
        : ColorConstants.blueBackground;
    final fg = isEmpty
        ? Colors.black.withValues(alpha: 0.45)
        : ColorConstants.mainColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg.withValues(alpha: 0.80),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPillSmall extends StatelessWidget {
  const _StatusPillSmall({required this.isComplete});

  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final bg = isComplete ? const Color(0xFFE7F7EE) : const Color(0xFFFFF3E6);
    final fg = isComplete ? const Color(0xFF1B7F3B) : const Color(0xFFB54708);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isComplete ? 'Lengkap' : 'Belum lengkap',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

class _RecapLoading extends StatelessWidget {
  const _RecapLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ColorConstants.borderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SkeletonBar(width: 140),
              SizedBox(height: 10),
              _SkeletonBar(width: 100, height: 12),
              SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: _SkeletonBar(width: 120, height: 34),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.width, this.height = 14});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _RecapEmpty extends StatelessWidget {
  const _RecapEmpty({required this.onPickMonth});

  final VoidCallback onPickMonth;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: ColorConstants.borderColor, width: 1),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: ColorConstants.blueBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.inbox_rounded,
                  color: ColorConstants.mainColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Belum ada data rekap',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Coba pilih bulan lain atau tarik untuk refresh.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: onPickMonth,
                icon: const Icon(Icons.calendar_month_rounded),
                label: const Text('Pilih bulan'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecapError extends StatelessWidget {
  const _RecapError({required this.message, required this.onRetry});

  final String? message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: ColorConstants.borderColor, width: 1),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECEC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: Color(0xFFB42318),
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat rekap',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorConstants.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                (message == null || message!.trim().isEmpty)
                    ? 'Silakan coba lagi.'
                    : message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () => onRetry(),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
