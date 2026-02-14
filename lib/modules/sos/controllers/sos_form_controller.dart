import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/sos/submit_sos_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SosFormController extends GetxController {
  SosFormController({required this.apiRepository});

  final ApiRepository apiRepository;

  final TextEditingController keteranganController = TextEditingController();
  final selectedPhoto = Rxn<XFile>();

  final isSubmitting = false.obs;
  final showInputError = false.obs;
  final formVersion = 0.obs;
  final RxString userId = ''.obs;

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

    final id = userId.value.trim();
    if (id.isEmpty) {
      EasyLoading.showError('User tidak valid, silakan login ulang');
      return;
    }

    final imageBytes = await photo.readAsBytes();
    if (imageBytes.isEmpty) {
      EasyLoading.showError('Foto tidak valid');
      return;
    }

    isSubmitting.value = true;
    EasyLoading.show(status: 'Menyimpan...');
    try {
      final fileName = photo.name.trim().isNotEmpty
          ? photo.name.trim()
          : photo.path.split(RegExp(r'[\\/]')).last;
      final req = SubmitSosRequest(
        idUser: id,
        keterangan: keteranganController.text.trim(),
        foto: MultipartFile(imageBytes, filename: fileName),
      );

      final res = await apiRepository.submitSos(req);
      if (res?.error == false) {
        EasyLoading.showSuccess(res?.message ?? 'Laporan SOS tersimpan');
        Get.back(result: true);
        return;
      }
      EasyLoading.showError(res?.message ?? 'Gagal menyimpan laporan SOS');
    } catch (_) {
      EasyLoading.showError('Gagal menyimpan laporan SOS');
    } finally {
      EasyLoading.dismiss();
      isSubmitting.value = false;
    }
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    userId.value = prefs.getString('userId') ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    _loadUsers();
  }

  @override
  void onClose() {
    keteranganController.dispose();
    super.onClose();
  }
}
