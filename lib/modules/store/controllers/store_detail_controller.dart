import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/patroli/patroli_id_request.dart';
import 'package:staffku/models/request/patroli/submit_patroli_request.dart';
import 'package:staffku/models/response/patroli/patroli_detail_response.dart';
import 'package:staffku/modules/home/base_controller.dart';

class StoreDetailController extends BaseController {
  StoreDetailController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final patroliId = ''.obs;
  final idJadwal = ''.obs;
  final namaJadwal = ''.obs;
  final status = ''.obs;

  final detail = Rxn<PatroliDetailData>();

  final keteranganController = TextEditingController();
  final selectedPhoto = Rxn<XFile>();

  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onReady() async {
    super.onReady();
    await loadUsers();

    final args = Get.arguments;
    if (args is Map) {
      patroliId.value = args['id']?.toString() ?? '';
      idJadwal.value = args['id_jadwal']?.toString() ?? '';
      namaJadwal.value = args['nama_jadwal']?.toString() ?? '';
      status.value = args['status']?.toString() ?? '';
    }

    await fetchDetail();
  }

  bool get isDone => status.value.trim() == '1';

  Future<void> fetchDetail() async {
    final id = patroliId.value.trim();
    if (id.isEmpty || id == '0') return;

    isLoading.value = true;
    try {
      final res = await apiRepository.detailPatroli(PatroliIdRequest(id: id));
      final data = res?.data;
      if (data == null || data.isEmpty) return;

      detail.value = data.first;
      if (keteranganController.text.trim().isEmpty) {
        keteranganController.text = detail.value?.keterangan ?? '';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickPhoto(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 75,
      );
      if (file != null) {
        selectedPhoto.value = file;
      }
    } catch (e) {
      EasyLoading.showError('Gagal mengambil foto');
    }
  }

  Future<void> submit() async {
    if (isDone) return;

    showInputError.value = false;

    if (!isConnectedToInternet.value) {
      EasyLoading.showError('Tidak ada koneksi internet');
      return;
    }

    final jadwal = idJadwal.value.trim();
    final keterangan = keteranganController.text.trim();
    final photo = selectedPhoto.value;

    if (jadwal.isEmpty) {
      EasyLoading.showError('ID jadwal tidak tersedia');
      return;
    }

    if (keterangan.isEmpty) {
      showInputError.value = true;
      EasyLoading.showError('Keterangan wajib diisi');
      return;
    }

    if (photo == null) {
      showInputError.value = true;
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
      final req = SubmitPatroliRequest(
        idUser: userId.value,
        idJadwal: jadwal,
        keterangan: keterangan,
        foto: MultipartFile(
          await photoFile.readAsBytes(),
          filename: photo.path.split('/').last,
        ),
      );

      final res = await apiRepository.submitPatroli(req);
      if (res?.error == false) {
        EasyLoading.showSuccess(res?.message ?? 'sukses');
        Get.back(result: true);
        return;
      }

      EasyLoading.showError(res?.message ?? 'Gagal menyimpan patroli');
    } finally {
      EasyLoading.dismiss();
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    keteranganController.dispose();
    super.onClose();
  }
}
