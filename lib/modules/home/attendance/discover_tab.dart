import 'dart:ui';

import 'package:staffku/modules/home/attendance/attendance_controller.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/services/face_recognition/face_recognition_wiget.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';

class DiscoverTab extends GetView<AttendanceController> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final sh = media.size.height;
    final bottomSafe = media.padding.bottom;

    const minSheet = 0.20;
    const initialSheet = 0.28;
    const maxSheet = 0.58;

    final mapPadding = EdgeInsets.only(
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
                mapType: MapType.terrain,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(controller.markers),
                circles: controller.circles,
              ),
            ),
          ),
          DraggableScrollableSheet(
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
                    isInOfficeArea: controller.isClockIn.value,
                    distanceText: controller.distanceToOffice.value,
                    timeIn: controller.timeIn.value,
                    timeOut: controller.timeOut.value,
                    durationText: controller.duration.value,
                    officeLocation: controller.officeLocation.value,
                    onRefresh: controller.onRefresh,
                    onOpenRecap: controller.goToRecapPages,
                    onClockIn: () => _openFaceCamera(context, 'Clock In'),
                    onClockOut: () => _openFaceCamera(context, 'Clock Out'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openFaceCamera(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FaceRecognitionWiget.faceCameraRecognizer(controller, type),
      ),
    );
  }
}

class _AttendancePanel extends StatelessWidget {
  const _AttendancePanel({
    required this.scrollController,
    required this.dateText,
    required this.isInOfficeArea,
    required this.distanceText,
    required this.timeIn,
    required this.timeOut,
    required this.durationText,
    required this.officeLocation,
    required this.onRefresh,
    required this.onOpenRecap,
    required this.onClockIn,
    required this.onClockOut,
  });

  final ScrollController scrollController;
  final String dateText;
  final bool isInOfficeArea;
  final String distanceText;
  final String timeIn;
  final String timeOut;
  final String durationText;
  final LatLng? officeLocation;
  final VoidCallback onRefresh;
  final VoidCallback onOpenRecap;
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
                        Row(
                          children: [
                            _StatusPill(isActive: isInOfficeArea),
                            if (distance.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Jarak: $distance',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.black.withValues(alpha: 0.55),
                                  ),
                                ),
                              ),
                            ],
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
                          isEnabled: isInOfficeArea,
                          timeValue: timeIn,
                          onTap: onClockIn,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _AttendanceActionTile(
                          title: 'Pulang',
                          icon: Icons.logout_rounded,
                          isEnabled: isInOfficeArea,
                          timeValue: timeOut,
                          onTap: onClockOut,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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

class _AttendanceActionTile extends StatelessWidget {
  const _AttendanceActionTile({
    required this.title,
    required this.icon,
    required this.isEnabled,
    required this.timeValue,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isEnabled;
  final String timeValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDone = timeValue != '--:--';
    final radius = BorderRadius.circular(18);

    final bg = isEnabled
        ? ColorConstants.blueBackground
        : Colors.black.withValues(alpha: 0.04);

    final borderColor = isEnabled
        ? ColorConstants.mainColor.withValues(alpha: 0.35)
        : Colors.transparent;

    final accent = isEnabled
        ? ColorConstants.mainColor
        : Colors.black.withValues(alpha: 0.35);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: (isEnabled && !isDone) ? onTap : null,
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
                  isDone
                      ? 'Tercatat'
                      : (isEnabled ? 'Tap untuk absen' : 'Di luar area'),
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
