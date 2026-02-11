import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/modules/sos/controllers/sos_list_controller.dart';
import 'package:staffku/modules/sos/models/sos_report.dart';

class SosFormController extends GetxController {
  SosFormController({required this.apiRepository});

  final ApiRepository apiRepository;

  final TextEditingController keteranganController = TextEditingController();
  final selectedPhoto = Rxn<XFile>();

  final isSubmitting = false.obs;
  final showInputError = false.obs;
  final formVersion = 0.obs;

  final ImagePicker _picker = ImagePicker();

  void markFormDirty() => formVersion.value++;

  bool get canSubmit {
    formVersion.value;
    return keteranganController.text.trim().isNotEmpty &&
        selectedPhoto.value != null;
  }

  Future<void> pickPhoto(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 80,
      );
      if (file != null) {
        selectedPhoto.value = file;
        markFormDirty();
      }
    } catch (_) {
      EasyLoading.showError('Gagal mengambil foto');
    }
  }

  Future<void> submit() async {
    showInputError.value = true;
    if (!canSubmit) {
      EasyLoading.showError('Keterangan dan foto wajib diisi');
      return;
    }

    final photo = selectedPhoto.value;
    if (photo == null) return;

    if (!GetPlatform.isWeb) {
      final file = File(photo.path);
      if (!(await file.exists())) {
        EasyLoading.showError('Foto tidak ditemukan');
        return;
      }
    }

    isSubmitting.value = true;
    try {
      final now = DateTime.now();
      final report = SosReport(
        id: now.millisecondsSinceEpoch,
        keterangan: keteranganController.text.trim(),
        photoPath: photo.path,
        createdAt: now,
      );

      await Get.find<SosListController>().addReport(report);
      EasyLoading.showSuccess('Laporan SOS tersimpan');
      Get.back(result: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    keteranganController.dispose();
    super.onClose();
  }
}

