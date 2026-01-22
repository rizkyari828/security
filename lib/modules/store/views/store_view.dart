import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/modules/store/controllers/store_list_controller.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/custom_appbar.dart';

class StoreView extends GetView<StoreListController> {
  @override
  Widget build(BuildContext context) {
    final scaleWidth = MediaQuery.of(context).size.width / 360;

    return Obx(
      () => Scaffold(
        appBar: CustomAppBarWithNetwork(
          title: 'Patroli',
          networkStatus: controller.qualityNetwork,
        ),
        floatingActionButton: controller.isConnectedToInternetWidget.value
            ? Padding(
                padding: EdgeInsets.only(left: scaleWidth * 30),
                child: controller.internetConnection(),
              )
            : const SizedBox(),
        backgroundColor: ColorConstants.lightGray,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: const WaterDropHeader(),
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: Obx(() => _body()),
        ),
      ),
    );
  }

  Widget _body() {
    final items = controller.listPatroli;

    if (controller.isLoading.value && items.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: ColorConstants.mainColor,
        ),
      );
    }

    final error = controller.errorMessage.value;
    if (error != null && items.isEmpty) {
      return _EmptyState(
        title: 'Gagal memuat jadwal',
        description: error,
        onRetry: controller.getPatroli,
      );
    }

    if (items.isEmpty) {
      return _EmptyState(
        title: 'Belum ada jadwal patroli',
        description: 'Tarik ke bawah untuk memuat ulang.',
        onRetry: controller.getPatroli,
      );
    }

    final total = items.length;
    final doneCount = items.where((e) {
      final status = (e.status ?? '0').trim();
      return status == '1' || status == 'pending_upload';
    }).length;
    final pendingCount = total - doneCount;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SummaryCard(
              total: total,
              done: doneCount,
              pending: pendingCount,
            ),
          );
        }

        final item = items[index - 1];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PatroliItemCard(
            title: (item.namaJadwal ?? '-').trim(),
            status: (item.status ?? '0').trim(),
            onTap: () => controller.goToDetailPages(item),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.total,
    required this.done,
    required this.pending,
  });

  final int total;
  final int done;
  final int pending;

  @override
  Widget build(BuildContext context) {
    final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shield_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Ringkasan Patroli',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SummaryMetric(label: 'Total', value: total.toString()),
              const SizedBox(width: 10),
              _SummaryMetric(label: 'Selesai', value: done.toString()),
              const SizedBox(width: 10),
              _SummaryMetric(label: 'Belum', value: pending.toString()),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.22),
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.95),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white.withValues(alpha: 0.16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatroliItemCard extends StatelessWidget {
  const _PatroliItemCard({
    required this.title,
    required this.status,
    required this.onTap,
  });

  final String title;
  final String status;
  final VoidCallback onTap;

  bool get _isDone => status == '1';

  bool get _isPendingUpload => status == 'pending_upload';

  @override
  Widget build(BuildContext context) {
    final statusColor = _isDone ? Colors.green : Colors.orange;
    final statusLabel = _isDone
        ? 'Selesai'
        : (_isPendingUpload ? 'Pending Upload' : 'Belum patroli');
    final statusIcon = _isDone
        ? Icons.check_rounded
        : (_isPendingUpload ? Icons.cloud_upload_rounded : Icons.schedule_rounded);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? '-' : title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorConstants.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StatusChip(color: statusColor, label: statusLabel),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: ColorConstants.darkGray),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.description,
    required this.onRetry,
  });

  final String title;
  final String description;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.assignment_rounded,
                size: 34,
                color: ColorConstants.mainColor,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ColorConstants.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstants.darkGray,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              buttonText: 'COBA LAGI',
              width: sw,
              onPressed: () => onRetry(),
            ),
          ],
        ),
      ),
    );
  }
}
