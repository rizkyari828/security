import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/modules/home/attendance/face_id/face_id_enroll_controller.dart';
import 'package:staffku/shared/services/face_recognition/face_recognition_wiget.dart';

class FaceIdEnrollPage extends StatefulWidget {
  const FaceIdEnrollPage({super.key, required this.userId});

  final String userId;

  @override
  State<FaceIdEnrollPage> createState() => _FaceIdEnrollPageState();
}

class _FaceIdEnrollPageState extends State<FaceIdEnrollPage> {
  late final FaceIdEnrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FaceIdEnrollController(userId: widget.userId);
  }

  @override
  void dispose() {
    _controller.faceCameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FaceRecognitionWiget.faceCameraRecognizer(_controller, 'Enroll'),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 74),
              child: Obx(() {
                final step = _controller.stepIndex.value + 1;
                final total = _controller.totalSteps.value;
                return _StepPill(
                  title: 'Daftar Face ID',
                  subtitle: 'Langkah $step/$total • ${_controller.stepTitle}',
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.80),
            ),
          ),
        ],
      ),
    );
  }
}

