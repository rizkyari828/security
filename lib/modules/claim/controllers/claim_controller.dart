import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/claim/submit_claim_request.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimController extends BaseController {
  ClaimController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  final TextEditingController nominalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  final selectedPhoto = Rxn<XFile>();
  final isSubmitting = false.obs;
  final formVersion = 0.obs;

  final ImagePicker _picker = ImagePicker();

  void markFormDirty() => formVersion.value++;

  bool get canSubmit {
    formVersion.value;
    return userId.value.trim().isNotEmpty &&
        nominalController.text.trim().isNotEmpty &&
        keteranganController.text.trim().isNotEmpty &&
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

  String _cleanNominal(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  Future<void> submit() async {
    showInputError.value = true;
    if (!canSubmit) {
      EasyLoading.showError('Nominal, keterangan, dan foto wajib diisi');
      return;
    }

    if (!isConnectedToInternet.value) {
      EasyLoading.showError('Tidak ada koneksi internet');
      return;
    }

    final id = userId.value.trim();
    final nominal = _cleanNominal(nominalController.text.trim());
    final keterangan = keteranganController.text.trim();
    final photo = selectedPhoto.value;

    if (nominal.isEmpty || int.tryParse(nominal) == null) {
      EasyLoading.showError('Nominal tidak valid');
      return;
    }

    if (photo == null) {
      EasyLoading.showError('Foto wajib diisi');
      return;
    }

    final photoFile = File(photo.path);
    if (!(await photoFile.exists())) {
      EasyLoading.showError('Foto tidak ditemukan');
      return;
    }

    isSubmitting.value = true;
    EasyLoading.show(status: 'Mengirim...');
    try {
      final req = SubmitClaimRequest(
        idUser: id,
        nominal: nominal,
        keterangan: keterangan,
        foto: MultipartFile(
          await photoFile.readAsBytes(),
          filename: photo.path.split('/').last,
        ),
      );

      final res = await apiRepository.submitClaim(req);
      if (res?.error == false) {
        EasyLoading.showSuccess(res?.message ?? 'Berhasil disimpan');
        Get.back(result: true);
        return;
      }

      EasyLoading.showError(res?.message ?? 'Gagal disimpan');
    } finally {
      EasyLoading.dismiss();
      isSubmitting.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    userId.value = prefs.getString('userId') ?? '';
    groupId.value = prefs.getString('groupId') ?? '';
  }

  @override
  void onClose() {
    nominalController.dispose();
    keteranganController.dispose();
    super.onClose();
  }
}
