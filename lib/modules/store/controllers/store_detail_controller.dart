import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/patroli/pending_patroli_upload.dart';
import 'package:staffku/models/request/patroli/patroli_id_request.dart';
import 'package:staffku/models/request/patroli/submit_patroli_request.dart';
import 'package:staffku/models/response/patroli/patroli_detail_response.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:path_provider/path_provider.dart';

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

  bool get isPendingUpload => status.value.trim() == 'pending_upload';

  bool get isDone => status.value.trim() == '1' || isPendingUpload;

  String get statusLabel {
    if (isPendingUpload) return 'Pending upload';
    return isDone ? 'Sudah patroli' : 'Belum patroli';
  }

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

    if (!isConnectedToInternet.value) {
      isSubmitting.value = true;
      EasyLoading.show(status: 'Menyimpan...');
      try {
        final savedPath = await _persistPendingPhoto(
          sourceFile: photoFile,
          idJadwal: jadwal,
        );

        await savePendingPatroliUpload(
          PendingPatroliUpload(
            idUser: userId.value,
            idJadwal: jadwal,
            keterangan: keterangan,
            fotoPath: savedPath,
            createdAtIso: DateTime.now().toIso8601String(),
          ),
        );

        status.value = 'pending_upload';
        EasyLoading.showSuccess('Patroli tersimpan, akan dikirim saat online');
        Get.back(result: 'pending_upload');
        return;
      } catch (_) {
        EasyLoading.showError('Gagal menyimpan patroli');
      } finally {
        EasyLoading.dismiss();
        isSubmitting.value = false;
      }
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

  Future<String> _persistPendingPhoto({
    required File sourceFile,
    required String idJadwal,
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final pendingDir = Directory('${docs.path}/pending_upload/patroli');
    if (!(await pendingDir.exists())) {
      await pendingDir.create(recursive: true);
    }

    final baseName = sourceFile.path.split(RegExp(r'[\\\\/]')).last;
    final dotIndex = baseName.lastIndexOf('.');
    final ext = dotIndex >= 0 ? baseName.substring(dotIndex) : '';
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final fileName = 'patroli_${idJadwal}_$timestamp$ext';
    final targetPath = '${pendingDir.path}/$fileName';
    final copied = await sourceFile.copy(targetPath);
    return copied.path;
  }

  @override
  void onClose() {
    keteranganController.dispose();
    super.onClose();
  }
}
