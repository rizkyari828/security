import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/modules/sos/controllers/sos_detail_controller.dart';
import 'package:staffku/modules/sos/utils/sos_image_utils.dart';
import 'package:staffku/shared/constants/constants.dart';
import 'package:staffku/shared/utils/common_widget.dart';

class SosDetailView extends GetView<SosDetailController> {
  const SosDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
      appBar: CommonWidget.appBar(title: 'Detail SOS'),
      body: Obx(() {
        final report = controller.report.value;
        if (report == null) {
          return Center(
            child: Text(
              'Data tidak ditemukan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black.withValues(alpha: 0.60),
              ),
            ),
          );
        }

        final imagePath = resolveSosImageUrl(report.img ?? '');
        final cdate = report.cdate;
        final user = (report.user ?? '').trim();
        final keterangan = (report.keterangan ?? '').trim();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _photoHero(imagePath),
                const SizedBox(height: 14),
                _metaCard(
                  title: 'Waktu',
                  value: cdate == null
                      ? '-'
                      : DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id_ID').format(cdate),
                  icon: Icons.schedule_rounded,
                ),
                const SizedBox(height: 10),
                _metaCard(
                  title: 'Pelapor',
                  value: user.isEmpty ? '-' : user,
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 10),
                _sectionCard(
                  title: 'Keterangan',
                  body: keterangan.isEmpty ? '-' : keterangan,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _photoHero(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 240,
        width: double.infinity,
        color: ColorConstants.backgroundTextField,
        child: _imageOrPlaceholder(path),
      ),
    );
  }

  Widget _imageOrPlaceholder(String path) {
    if (path.trim().isEmpty) {
      return Icon(
        Icons.image_not_supported_rounded,
        color: Colors.black.withValues(alpha: 0.35),
      );
    }

    final isNetwork =
        path.startsWith('http://') || path.startsWith('https://');
    if (kIsWeb || isNetwork) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }

    final file = File(path);
    if (!file.existsSync()) return _placeholder();
    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Icon(Icons.image_rounded, color: Colors.black.withValues(alpha: 0.35));
  }

  Widget _metaCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
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
      child: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: ColorConstants.mainColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: ColorConstants.mainColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: ColorConstants.black,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
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
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: ColorConstants.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black.withValues(alpha: 0.72),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
