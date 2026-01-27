import 'dart:io';
import 'dart:ui';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/shared/constants/colors.dart';

const bool _forceManualCapture = bool.fromEnvironment(
  'FACE_MANUAL_CAPTURE',
  defaultValue: false,
);

class FaceRecognitionWiget {
  static Widget faceCameraRecognizer(dynamic controller, String status) {
    final label = _statusLabel(status);
    final allowLoosePositioning = status.trim().toLowerCase() == 'enroll';

    return Obx(() {
      final capturedPath = controller.faceCameraCapture?.value.path ?? '';
      final hasCapture = capturedPath.isNotEmpty;

      return Scaffold(
        backgroundColor: Colors.black,
        body: hasCapture
            ? _CapturePreview(
                imageFile: controller.faceCameraCapture?.value ?? File(''),
                label: label,
                onRetake: () async {
                  await controller.faceCameraController.startImageStream();
                  controller.faceCameraCapture?.value = File('');
                },
                onSubmit: () async {
                  if (status.toLowerCase() == 'clock out') {
                    controller.submitOut(status);
                  } else {
                    controller.submit(status);
                  }
                },
              )
            : _LiveCamera(
                controller: controller.faceCameraController,
                label: label,
                allowLoosePositioning: allowLoosePositioning,
              ),
      );
    });
  }

  static String _statusLabel(String status) {
    final normalized = status.trim().toLowerCase();
    if (normalized == 'enroll') return 'Daftar Wajah';
    if (normalized == 'clock out') return 'Pulang';
    if (normalized == 'clock in') return 'Datang';
    return status.trim().isEmpty ? 'Absensi' : status;
  }
}

class _LiveCamera extends StatelessWidget {
  const _LiveCamera({
    required this.controller,
    required this.label,
    required this.allowLoosePositioning,
  });

  final FaceCameraController controller;
  final String label;
  final bool allowLoosePositioning;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SmartFaceCamera(
            controller: controller,
            showControls: false,
            indicatorShape: IndicatorShape.none,
            messageBuilder: (_, __) => const SizedBox.shrink(),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _FaceGuidePainter(
                overlayColor: Colors.black.withValues(alpha: 0.08),
                borderColor: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: _CameraHeader(label: label),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _CameraBottomBar(
              controller: controller,
              allowLoosePositioning: allowLoosePositioning,
            ),
          ),
        ),
      ],
    );
  }
}

class _CapturePreview extends StatelessWidget {
  const _CapturePreview({
    required this.imageFile,
    required this.label,
    required this.onRetake,
    required this.onSubmit,
  });

  final File imageFile;
  final String label;
  final VoidCallback onRetake;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const ColoredBox(color: Colors.black),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.70),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: _CameraHeader(label: label, showSubtitle: false),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _PreviewBottomActions(
              label: label,
              onRetake: onRetake,
              onSubmit: onSubmit,
            ),
          ),
        ),
      ],
    );
  }
}

class _CameraHeader extends StatelessWidget {
  const _CameraHeader({required this.label, this.showSubtitle = true});

  final String label;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: Get.back,
            icon: const Icon(Icons.arrow_back_rounded),
            color: Colors.white,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Absensi Wajah',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (showSubtitle) ...[
                  const SizedBox(height: 2),
                  Text(
                    '$label • Pastikan wajah terlihat jelas',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraBottomBar extends StatefulWidget {
  const _CameraBottomBar({
    required this.controller,
    required this.allowLoosePositioning,
  });

  final FaceCameraController controller;
  final bool allowLoosePositioning;

  @override
  State<_CameraBottomBar> createState() => _CameraBottomBarState();
}

class _CameraBottomBarState extends State<_CameraBottomBar> {
  late bool manualMode = _forceManualCapture;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, _) {
        final detected = (state as dynamic)?.detectedFace as DetectedFace?;
        final wellPositioned = detected?.wellPositioned == true;
        final hasFace = detected?.face != null;
        final controlsEnabled = controller.enableControls;
        final allowLoose = widget.allowLoosePositioning;

        final statusText = !hasFace
            ? 'Wajah belum terdeteksi'
            : (wellPositioned || allowLoose
                  ? 'Siap difoto'
                  : 'Posisikan wajah di tengah');

        final statusColor = !hasFace
            ? const Color(0xFFB42318)
            : ((wellPositioned || allowLoose)
                  ? const Color(0xFF1B7F3B)
                  : const Color(0xFFB54708));

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        manualMode ? 'Mode manual' : statusText,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (kDebugMode) ...[
                  _RoundIconButton(
                    tooltip: manualMode ? 'Matikan mode manual' : 'Mode manual',
                    icon: manualMode
                        ? Icons.handyman_rounded
                        : Icons.handyman_outlined,
                    onPressed: () => setState(() => manualMode = !manualMode),
                  ),
                  const SizedBox(width: 10),
                ],
                _RoundIconButton(
                  tooltip: 'Flash',
                  icon: _flashIcon(state),
                  onPressed: controlsEnabled
                      ? controller.changeFlashMode
                      : null,
                ),
                const SizedBox(width: 10),
                _RoundIconButton(
                  tooltip: 'Ganti kamera',
                  icon: Icons.cameraswitch_rounded,
                  onPressed: controlsEnabled
                      ? controller.changeCameraLens
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _CaptureButton(
              enabled:
                  manualMode
                      ? true
                      : (controlsEnabled &&
                          (wellPositioned || (allowLoose && hasFace))),
              onPressed: controller.captureImage,
            ),
          ],
        );
      },
    );
  }

  static IconData _flashIcon(dynamic state) {
    final available =
        (state as dynamic)?.availableFlashMode as List<CameraFlashMode>? ??
        const <CameraFlashMode>[];
    final currentIndex = (state as dynamic)?.currentFlashMode as int? ?? 0;
    final mode = available.isEmpty
        ? CameraFlashMode.off
        : available[(currentIndex < 0 || currentIndex >= available.length)
              ? 0
              : currentIndex];
    return mode == CameraFlashMode.always
        ? Icons.flash_on_rounded
        : mode == CameraFlashMode.off
        ? Icons.flash_off_rounded
        : Icons.flash_auto_rounded;
  }
}

class _PreviewBottomActions extends StatelessWidget {
  const _PreviewBottomActions({
    required this.label,
    required this.onRetake,
    required this.onSubmit,
  });

  final String label;
  final VoidCallback onRetake;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Foto siap dikirim • $label',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onRetake,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'ULANGI',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: onSubmit,
                      style: FilledButton.styleFrom(
                        backgroundColor: ColorConstants.mainColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'KIRIM',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
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
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Tooltip(
          message: tooltip,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            child: Icon(
              icon,
              color: onPressed == null
                  ? Colors.white.withValues(alpha: 0.35)
                  : Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.45,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ColorConstants.mainColor,
                  ColorConstants.secondaryColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.mainColor.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Container(
                height: 62,
                width: 62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: ColorConstants.mainColor,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FaceGuidePainter extends CustomPainter {
  _FaceGuidePainter({required this.overlayColor, required this.borderColor});

  final Color overlayColor;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = overlayColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final rect = Offset.zero & size;
    final holeWidth = size.width * 0.78;
    final holeHeight = size.height * 0.50;
    final holeRect = Rect.fromCenter(
      center: Offset(rect.center.dx, size.height * 0.44),
      width: holeWidth,
      height: holeHeight,
    );

    final outerPath = Path()..addRect(rect);
    final holePath = Path()..addRRect(RRect.fromRectXY(holeRect, 999, 999));
    final diff = Path.combine(PathOperation.difference, outerPath, holePath);
    canvas.drawPath(diff, overlayPaint);

    canvas.drawRRect(RRect.fromRectXY(holeRect, 999, 999), borderPaint);

    final cornerPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final cornerLen = 18.0;
    final r = RRect.fromRectXY(holeRect, 999, 999);
    final tl = r.outerRect.topLeft + const Offset(14, 14);
    final tr = r.outerRect.topRight + const Offset(-14, 14);
    final bl = r.outerRect.bottomLeft + const Offset(14, -14);
    final br = r.outerRect.bottomRight + const Offset(-14, -14);

    canvas.drawLine(tl, tl + Offset(cornerLen, 0), cornerPaint);
    canvas.drawLine(tl, tl + Offset(0, cornerLen), cornerPaint);

    canvas.drawLine(tr, tr + Offset(-cornerLen, 0), cornerPaint);
    canvas.drawLine(tr, tr + Offset(0, cornerLen), cornerPaint);

    canvas.drawLine(bl, bl + Offset(cornerLen, 0), cornerPaint);
    canvas.drawLine(bl, bl + Offset(0, -cornerLen), cornerPaint);

    canvas.drawLine(br, br + Offset(-cornerLen, 0), cornerPaint);
    canvas.drawLine(br, br + Offset(0, -cornerLen), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _FaceGuidePainter oldDelegate) =>
      oldDelegate.overlayColor != overlayColor ||
      oldDelegate.borderColor != borderColor;
}
