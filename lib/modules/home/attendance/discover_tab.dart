import 'dart:ui';
import 'dart:async';

import 'package:staffku/modules/home/attendance/attendance_controller.dart';
import 'package:staffku/modules/home/attendance/face_id/face_id_enroll_page.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/services/face_recognition/face_recognition_wiget.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class DiscoverTab extends StatefulWidget {
  const DiscoverTab({super.key});

  @override
  State<DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> {
  static const minSheet = 0.20;
  static const initialSheet = 0.28;
  static const maxSheet = 0.58;
  static const mapControlTopInset = 12.0;
  static const mapSideInset = 12.0;
  static const mapControlHideExtent = 0.34;

  final AttendanceController controller = Get.find<AttendanceController>();
  final ValueNotifier<double> _sheetExtent = ValueNotifier<double>(initialSheet);
  final ValueNotifier<bool> _mapControlsVisible = ValueNotifier<bool>(
    initialSheet <= mapControlHideExtent,
  );
  Timer? _sheetSettleDebounce;

  @override
  void dispose() {
    _sheetSettleDebounce?.cancel();
    _sheetExtent.dispose();
    _mapControlsVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final sh = media.size.height;
    final topSafe = media.padding.top;
    final bottomSafe = media.padding.bottom;
    final mapPadding = EdgeInsets.only(
      top: topSafe + mapControlTopInset,
      left: mapSideInset,
      right: mapSideInset,
      bottom: (sh * maxSheet) + bottomSafe + 24,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(
              () => GoogleMap(
                padding: mapPadding,
                initialCameraPosition: CameraPosition(
                  target: controller.myLocation,
                  zoom: 18.0,
                ),
                onMapCreated: controller.onMapCreated,
                onCameraMove: controller.onMapCameraMove,
                mapType: MapType.terrain,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                markers: Set<Marker>.of(controller.markers),
                circles: controller.circles,
              ),
            ),
          ),
          Positioned(
            top: topSafe + mapControlTopInset,
            right: mapSideInset,
            child: ValueListenableBuilder<bool>(
              valueListenable: _mapControlsVisible,
              builder: (context, showControls, _) {
                return IgnorePointer(
                  ignoring: !showControls,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    offset: showControls
                        ? Offset.zero
                        : const Offset(0.0, -0.16),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      opacity: showControls ? 1.0 : 0.0,
                      child: _MapControls(
                        onMyLocation: () => controller.focusMapToCurrentLocation(),
                        onZoomIn: () => controller.zoomInMap(),
                        onZoomOut: () => controller.zoomOutMap(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              _sheetExtent.value = notification.extent;
              _mapControlsVisible.value = false;
              _sheetSettleDebounce?.cancel();
              _sheetSettleDebounce = Timer(
                const Duration(milliseconds: 200),
                () {
                  if (!mounted) return;
                  _mapControlsVisible.value =
                      _sheetExtent.value <= mapControlHideExtent;
                },
              );
              return false;
            },
            child: DraggableScrollableSheet(
              initialChildSize: initialSheet,
              minChildSize: minSheet,
              maxChildSize: maxSheet,
              builder: (context, scrollController) {
                return SafeArea(
                  top: false,
                  minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Obx(
                    () => _AttendancePanel(
                      scrollController: scrollController,
                      dateText: DateFormat(
                        "EEEE, d MMMM yyyy",
                        "id_ID",
                      ).format(DateTime.now()),
                      isInOfficeArea: controller.isWithinAttendanceArea.value,
                      isFaceIdReady: controller.isFaceIdReady.value,
                      distanceText: controller.distanceToOffice.value,
                      timeIn: controller.timeIn.value,
                      timeOut: controller.timeOut.value,
                      durationText: controller.duration.value,
                      officeLocation: controller.officeLocation.value,
                      isPreparingClockAction:
                          controller.isPreparingClockAction.value,
                      isRefreshingFaceData:
                          controller.isRefreshingFaceData.value,
                      onRefresh: controller.onRefresh,
                      onOpenRecap: controller.goToRecapPages,
                      onUpdateFaceId: () => _openFaceEnrollment(context),
                      onClockIn: () => _openFaceCamera(context, 'Clock In'),
                      onClockOut: () => _openFaceCamera(context, 'Clock Out'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openFaceCamera(BuildContext context, String type) {
    () async {
      if (controller.isPreparingClockAction.value) return;
      controller.isPreparingClockAction.value = true;
      try {
        await controller.loadUsers();
        final userId = controller.userId.value.trim();
        if (userId.isEmpty) {
          Get.snackbar(
            "Error",
            "User belum tersedia, silakan login ulang.",
            icon: const Icon(Icons.error_outline, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            borderRadius: 20,
            margin: const EdgeInsets.all(15),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
          return;
        }

        await controller.validateAttandance();
        if (!controller.isFaceIdReady.value) {
          final hasFaceData = controller.serverFaceEmbeddings.isNotEmpty;
          if (!context.mounted) return;
          final goEnroll = await _showEnrollRequiredDialog(
            context,
            hasFaceData: hasFaceData,
          );
          if (goEnroll != true) {
            return;
          }

          final enrolled = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => FaceIdEnrollPage(userId: userId)),
          );
          if (enrolled != true) return;

          controller.isRefreshingFaceData.value = true;
          await controller.validateAttandance();
          controller.isRefreshingFaceData.value = false;
          if (!controller.isFaceIdReady.value) {
            Get.snackbar(
              "Error",
              controller.serverFaceEmbeddings.isNotEmpty
                  ? "Face ID tersimpan tapi format data tidak valid, coba daftar ulang."
                  : "Face ID belum tersimpan di server, coba ulangi pendaftaran.",
              icon: const Icon(Icons.error_outline, color: Colors.white),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              borderRadius: 20,
              margin: const EdgeInsets.all(15),
              colorText: Colors.white,
              duration: const Duration(seconds: 4),
            );
            return;
          }

          if (!context.mounted) return;
          await _showEnrollSuccessDialog(context, type);
          return;
        }

        if (!context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FaceRecognitionWiget.faceCameraRecognizer(controller, type),
          ),
        );
      } finally {
        controller.isRefreshingFaceData.value = false;
        controller.isPreparingClockAction.value = false;
      }
    }();
  }

  Future<bool?> _showEnrollRequiredDialog(
    BuildContext context, {
    required bool hasFaceData,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text(
          hasFaceData ? 'Face ID Perlu Diperbarui' : 'Face ID Belum Terdaftar',
        ),
        content: Text(
          hasFaceData
              ? 'Data Face ID ditemukan tetapi tidak valid. Untuk melanjutkan absensi, perbarui Face ID terlebih dahulu.'
              : 'Untuk melanjutkan absensi, daftarkan Face ID terlebih dahulu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:
                Text(hasFaceData ? 'Perbarui Sekarang' : 'Daftarkan Sekarang'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEnrollSuccessDialog(
      BuildContext context, String type) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: const Text('Face ID Berhasil Didaftarkan'),
        content: Text(
          'Data wajah sudah tersimpan dan diperbarui. Tekan tombol ${type == 'Clock Out' ? 'Clock Out' : 'Clock In'} sekali lagi untuk melanjutkan absensi.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openFaceEnrollment(BuildContext context) {
    () async {
      if (controller.isPreparingClockAction.value) return;
      controller.isPreparingClockAction.value = true;
      try {
        await controller.loadUsers();
        final userId = controller.userId.value.trim();
        if (userId.isEmpty) {
          Get.snackbar(
            "Error",
            "User belum tersedia, silakan login ulang.",
            icon: const Icon(Icons.error_outline, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            borderRadius: 20,
            margin: const EdgeInsets.all(15),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
          return;
        }

        final enrolled = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => FaceIdEnrollPage(userId: userId)),
        );
        if (enrolled != true) return;

        controller.isRefreshingFaceData.value = true;
        await controller.validateAttandance();
        controller.isRefreshingFaceData.value = false;
      } finally {
        controller.isRefreshingFaceData.value = false;
        controller.isPreparingClockAction.value = false;
      }
    }();
  }
}

class _AttendancePanel extends StatelessWidget {
  const _AttendancePanel({
    required this.scrollController,
    required this.dateText,
    required this.isInOfficeArea,
    required this.isFaceIdReady,
    required this.distanceText,
    required this.timeIn,
    required this.timeOut,
    required this.durationText,
    required this.officeLocation,
    required this.isPreparingClockAction,
    required this.isRefreshingFaceData,
    required this.onRefresh,
    required this.onOpenRecap,
    required this.onUpdateFaceId,
    required this.onClockIn,
    required this.onClockOut,
  });

  final ScrollController scrollController;
  final String dateText;
  final bool isInOfficeArea;
  final bool isFaceIdReady;
  final String distanceText;
  final String timeIn;
  final String timeOut;
  final String durationText;
  final LatLng? officeLocation;
  final bool isPreparingClockAction;
  final bool isRefreshingFaceData;
  final VoidCallback onRefresh;
  final VoidCallback onOpenRecap;
  final VoidCallback onUpdateFaceId;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(24);
    final surfaceColor = Colors.white.withValues(alpha: 0.92);
    final distance = distanceText.trim();
    final hasOffice = officeLocation != null;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: surfaceColor,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              IgnorePointer(
                ignoring: isPreparingClockAction,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateText,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _StatusPill(isActive: isInOfficeArea),
                                  _FaceIdPill(isReady: isFaceIdReady),
                                  if (distance.isNotEmpty)
                                    Text(
                                      'Jarak: $distance',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Colors.black
                                            .withValues(alpha: 0.55),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _IconCircleButton(
                          tooltip: 'Refresh',
                          icon: Icons.refresh_rounded,
                          onPressed: onRefresh,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 118),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _AttendanceActionTile(
                                title: 'Datang',
                                icon: Icons.login_rounded,
                                isEnabled: isInOfficeArea && isFaceIdReady,
                                isFaceIdReady: isFaceIdReady,
                                isBusy: isPreparingClockAction,
                                timeValue: timeIn,
                                onTap: onClockIn,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _AttendanceActionTile(
                                title: 'Pulang',
                                icon: Icons.logout_rounded,
                                isEnabled: isInOfficeArea && isFaceIdReady,
                                isFaceIdReady: isFaceIdReady,
                                isBusy: isPreparingClockAction,
                                timeValue: timeOut,
                                onTap: onClockOut,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isFaceIdReady) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE7C98E),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.face_retouching_off_rounded,
                              color: Color(0xFFB54708),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Face ID belum siap. Perbarui Face ID untuk mulai absen.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.black.withValues(alpha: 0.75),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            OutlinedButton(
                              onPressed: isPreparingClockAction
                                  ? null
                                  : onUpdateFaceId,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFB54708),
                                ),
                                foregroundColor: const Color(0xFFB54708),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: const Text('Perbarui'),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isRefreshingFaceData) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Memperbarui data wajah...',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.60),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 12),
                    _DetailCard(
                      durationText: durationText,
                      timeIn: timeIn,
                      timeOut: timeOut,
                      hasOffice: hasOffice,
                      officeLocation: officeLocation,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      elevation: 0,
                      borderColor: Colors.transparent,
                      buttonColor: ColorConstants.mainColor,
                      buttonTextColor: Colors.white,
                      buttonText: 'RIWAYAT KEDATANGAN',
                      width: double.infinity,
                      onPressed: onOpenRecap,
                    ),
                  ],
                ),
              ),
              if (isPreparingClockAction)
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.55),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Menyiapkan proses absensi...',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.black.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.durationText,
    required this.timeIn,
    required this.timeOut,
    required this.hasOffice,
    required this.officeLocation,
  });

  final String durationText;
  final String timeIn;
  final String timeOut;
  final bool hasOffice;
  final LatLng? officeLocation;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(18);
    final muted = Colors.black.withValues(alpha: 0.55);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.03),
        borderRadius: radius,
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: muted, size: 18),
              const SizedBox(width: 8),
              Text(
                'Detail hari ini',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Masuk',
                  value: (timeIn == '--:--') ? '-' : timeIn,
                  icon: Icons.login_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Metric(
                  label: 'Pulang',
                  value: (timeOut == '--:--') ? '-' : timeOut,
                  icon: Icons.logout_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Metric(
                  label: 'Durasi',
                  value: (durationText == '--:--') ? '-' : durationText,
                  icon: Icons.timer_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hasOffice
                ? 'Radius absensi: 150 m • Kantor: ${officeLocation!.latitude.toStringAsFixed(5)}, ${officeLocation!.longitude.toStringAsFixed(5)}'
                : 'Radius absensi: 150 m',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: muted),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: ColorConstants.mainColor),
              const Spacer(),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ColorConstants.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bg = isActive ? const Color(0xFFE7F7EE) : const Color(0xFFFDECEC);
    final fg = isActive ? const Color(0xFF1B7F3B) : const Color(0xFFB42318);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isActive ? 'Di area absensi' : 'Di luar area',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _FaceIdPill extends StatelessWidget {
  const _FaceIdPill({required this.isReady});

  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final bg = isReady ? const Color(0xFFE6F5FF) : const Color(0xFFFFF4E5);
    final fg = isReady ? const Color(0xFF0D5EA6) : const Color(0xFFB54708);
    final icon =
        isReady ? Icons.verified_rounded : Icons.report_gmailerrorred_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            isReady ? 'Face ID Ready' : 'Face ID Not Ready',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({
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
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              size: 22,
              color: Colors.black.withValues(alpha: 0.55),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapControls extends StatelessWidget {
  const _MapControls({
    required this.onMyLocation,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  final VoidCallback onMyLocation;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    final cardColor = Colors.white.withValues(alpha: 0.94);
    final borderColor = Colors.black.withValues(alpha: 0.08);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _MapControlButton(
          tooltip: 'Lokasi Saya',
          icon: Icons.my_location_rounded,
          onTap: onMyLocation,
          cardColor: cardColor,
          borderColor: borderColor,
        ),
        const SizedBox(height: 8),
        Container(
          width: 46,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MapControlButton(
                tooltip: 'Zoom In',
                icon: Icons.add_rounded,
                onTap: onZoomIn,
                cardColor: Colors.transparent,
                borderColor: Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black.withValues(alpha: 0.07),
              ),
              _MapControlButton(
                tooltip: 'Zoom Out',
                icon: Icons.remove_rounded,
                onTap: onZoomOut,
                cardColor: Colors.transparent,
                borderColor: Colors.transparent,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    required this.cardColor,
    required this.borderColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final Color cardColor;
  final Color borderColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Tooltip(
          message: tooltip,
          child: Ink(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: borderRadius,
              border: Border.all(color: borderColor),
              boxShadow: cardColor == Colors.transparent
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.16),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: Icon(
              icon,
              size: 22,
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _AttendanceActionTile extends StatelessWidget {
  const _AttendanceActionTile({
    required this.title,
    required this.icon,
    required this.isEnabled,
    required this.isFaceIdReady,
    required this.isBusy,
    required this.timeValue,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isEnabled;
  final bool isFaceIdReady;
  final bool isBusy;
  final String timeValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDone = timeValue != '--:--';
    final radius = BorderRadius.circular(18);

    final bg = (isEnabled && !isBusy)
        ? ColorConstants.blueBackground
        : Colors.black.withValues(alpha: 0.04);

    final borderColor = (isEnabled && !isBusy)
        ? ColorConstants.mainColor.withValues(alpha: 0.35)
        : Colors.transparent;

    final accent = (isEnabled && !isBusy)
        ? ColorConstants.mainColor
        : Colors.black.withValues(alpha: 0.35);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: (isEnabled && !isDone && !isBusy) ? onTap : null,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: accent),
                    const Spacer(),
                    if (isDone)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF1B7F3B),
                      ),
                  ],
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: isDone
                      ? Text(
                          timeValue,
                          key: ValueKey('done_$timeValue'),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        )
                      : TimerBuilder.periodic(
                          const Duration(seconds: 1),
                          builder: (context) {
                            return Text(
                              DateFormat(
                                "HH:mm:ss",
                                "id_ID",
                              ).format(DateTime.now()),
                              key: const ValueKey('live'),
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  isBusy
                      ? 'Memproses...'
                      : !isFaceIdReady
                          ? 'Face ID belum siap'
                          : isDone
                              ? 'Tercatat'
                              : (isEnabled
                                  ? 'Tap untuk absen'
                                  : 'Di luar area'),
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
        ),
      ),
    );
  }
}
