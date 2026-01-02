import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/payslip/download_payslip_request.dart';
import 'package:sales/modules/home/base_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayslipController extends BaseController {
  PayslipController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  final TextEditingController periodeController = TextEditingController();

  final Rx<DateTime> selectedPeriode =
      DateTime(DateTime.now().year, DateTime.now().month).obs;

  final RxBool isDownloading = false.obs;
  final RxnString lastSavedPath = RxnString();

  @override
  void onReady() {
    super.onReady();
    _loadUsers();
    _syncPeriodeText();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    userId.value = prefs.getString('userId') ?? '';
    groupId.value = prefs.getString('groupId') ?? '';
    name.value = prefs.getString('name') ?? '';
  }

  void _syncPeriodeText() {
    periodeController.text =
        DateFormat('MMMM yyyy', 'id_ID').format(selectedPeriode.value);
  }

  Future<void> pickPeriode(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: selectedPeriode.value,
      firstDate: DateTime(DateTime.now().year - 3, 1),
      lastDate: DateTime(DateTime.now().year + 1, 12),
    );
    if (picked == null) return;
    selectedPeriode.value = DateTime(picked.year, picked.month);
    _syncPeriodeText();
  }

  Future<void> downloadExcel() async {
    // Backward-compatible alias (button now uses PDF).
    await downloadPdf();
  }

  Future<void> downloadPdf() async {
    if (userId.value.trim().isEmpty) {
      EasyLoading.showError('User tidak valid');
      return;
    }
    if (isDownloading.value) return;

    final month = selectedPeriode.value.month.toString().padLeft(2, '0');
    final year = selectedPeriode.value.year.toString();

    isDownloading.value = true;
    EasyLoading.show(status: 'Menyiapkan payslip...');
    try {
      EasyLoading.show(status: 'Mengambil link payslip...');
      final result = await apiRepository.downloadPayslipPdf(
        DownloadPayslipRequest(
          userId: userId.value,
          month: month,
          year: year,
        ),
      );
      if (result == null) return;

      EasyLoading.show(status: 'Mengunduh file payslip...');
      final fileName = _sanitizeFilename(
        _ensurePdfExtension(result.filename ?? 'payslip_${year}_$month.pdf'),
      );

      var directory = await _resolveDownloadDirectory();
      var filePath = '${directory.path}${Platform.pathSeparator}$fileName';
      var savedInDownload = directory.path.toLowerCase().contains('download');

      try {
        final file = File(filePath);
        await file.writeAsBytes(result.bytes, flush: true);
      } on FileSystemException {
        directory = await _resolveAppPayslipsDirectory();
        filePath = '${directory.path}${Platform.pathSeparator}$fileName';
        savedInDownload = false;
        final file = File(filePath);
        await file.writeAsBytes(result.bytes, flush: true);
      }

      lastSavedPath.value = filePath;
      EasyLoading.showSuccess(
        savedInDownload ? 'Payslip tersimpan di Download' : 'Payslip tersimpan',
      );
      await OpenFilex.open(filePath);
    } catch (e) {
      EasyLoading.showError('Gagal download payslip');
    } finally {
      EasyLoading.dismiss();
      isDownloading.value = false;
    }
  }

  Future<void> openLastFile() async {
    final path = lastSavedPath.value;
    if (path == null || path.isEmpty) return;
    await OpenFilex.open(path);
  }

  String _sanitizeFilename(String input) {
    final cleaned = input.replaceAll(RegExp(r'[\\\\/:*?\"<>|]'), '_').trim();
    return cleaned.isEmpty ? 'payslip.pdf' : cleaned;
  }

  String _ensurePdfExtension(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return 'payslip.pdf';
    if (trimmed.toLowerCase().endsWith('.pdf')) return trimmed;
    return '$trimmed.pdf';
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      final candidates = <String>[
        '${Platform.pathSeparator}storage${Platform.pathSeparator}emulated${Platform.pathSeparator}0${Platform.pathSeparator}Download',
        '${Platform.pathSeparator}sdcard${Platform.pathSeparator}Download',
      ];
      for (final path in candidates) {
        try {
          final dir = Directory(path);
          if (await dir.exists()) return dir;
        } catch (_) {}
      }
    }

    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) return downloads;
    } catch (_) {}

    return _resolveAppPayslipsDirectory();
  }

  Future<Directory> _resolveAppPayslipsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final fallback =
        Directory('${directory.path}${Platform.pathSeparator}payslips');
    await fallback.create(recursive: true);
    return fallback;
  }

  @override
  void onClose() {
    periodeController.dispose();
    super.onClose();
  }
}
