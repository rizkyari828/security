import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/payslip/download_payslip_request.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SavedPayslipFile {
  const _SavedPayslipFile({
    required this.path,
    required this.locationLabel,
  });

  final String path;
  final String locationLabel;
}

class PayslipController extends BaseController {
  PayslipController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  static const _lastSavedPathKey = 'lastPayslipPath';
  static const _lastSavedLocationKey = 'lastPayslipLocation';

  final TextEditingController periodeController = TextEditingController();

  final Rx<DateTime> selectedPeriode = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  ).obs;

  final RxBool isDownloading = false.obs;
  final RxnString lastSavedPath = RxnString();
  final RxnString lastSavedLocationLabel = RxnString();
  final RxnString lastDownloadMessage = RxnString();
  final RxBool lastDownloadSuccess = false.obs;

  @override
  void onReady() {
    super.onReady();
    _loadUsers();
    _restoreLastSavedInfo();
    _syncPeriodeText();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    userId.value = prefs.getString('userId') ?? '';
    groupId.value = prefs.getString('groupId') ?? '';
    name.value = prefs.getString('name') ?? '';
  }

  void _restoreLastSavedInfo() {
    final prefs = Get.find<SharedPreferences>();
    lastSavedPath.value = prefs.getString(_lastSavedPathKey);
    lastSavedLocationLabel.value = prefs.getString(_lastSavedLocationKey);
  }

  Future<void> _persistLastSavedInfo(_SavedPayslipFile saved) async {
    final prefs = Get.find<SharedPreferences>();
    await prefs.setString(_lastSavedPathKey, saved.path);
    await prefs.setString(_lastSavedLocationKey, saved.locationLabel);
  }

  void _syncPeriodeText() {
    periodeController.text = DateFormat(
      'MMMM yyyy',
      'id_ID',
    ).format(selectedPeriode.value);
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
    lastDownloadMessage.value = null;
    EasyLoading.show(status: 'Menyiapkan payslip...');
    try {
      EasyLoading.show(status: 'Mengambil link payslip...');
      final result = await apiRepository.downloadPayslipPdf(
        DownloadPayslipRequest(userId: userId.value, month: month, year: year),
      );
      if (result == null) {
        lastDownloadMessage.value = 'Payslip tidak ditemukan atau gagal diunduh';
        lastDownloadSuccess.value = false;
        return;
      }

      EasyLoading.show(status: 'Mengunduh file payslip...');
      final fileName = _sanitizeFilename(
        _ensurePdfExtension(result.filename ?? 'payslip_${year}_$month.pdf'),
      );

      final saved = await _savePayslipBytes(
        bytes: result.bytes,
        fileName: fileName,
      );

      lastSavedPath.value = saved.path;
      lastSavedLocationLabel.value = saved.locationLabel;
      await _persistLastSavedInfo(saved);

      lastDownloadMessage.value = 'Payslip tersimpan di ${saved.locationLabel}';
      lastDownloadSuccess.value = true;
      EasyLoading.showSuccess(lastDownloadMessage.value!);

      final openResult = await OpenFilex.open(saved.path);
      if (openResult.type != ResultType.done) {
        EasyLoading.showInfo(
          'File tersimpan, tapi tidak bisa dibuka otomatis (${openResult.message})',
        );
      }
    } catch (e) {
      lastDownloadMessage.value = 'Gagal download payslip';
      lastDownloadSuccess.value = false;
      EasyLoading.showError(lastDownloadMessage.value!);
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

  Future<void> copyLastSavedPath() async {
    final path = lastSavedPath.value;
    if (path == null || path.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: path));
    EasyLoading.showSuccess('Lokasi file disalin');
  }

  String lastSavedFilename() {
    final path = lastSavedPath.value;
    if (path == null || path.trim().isEmpty) return '-';
    final normalized = path.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isNotEmpty ? parts.last : path;
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

  Future<_SavedPayslipFile> _savePayslipBytes({
    required List<int> bytes,
    required String fileName,
  }) async {
    final candidates = await _resolveSaveDirectories();

    for (final entry in candidates) {
      final dir = entry.$1;
      final label = entry.$2;
      try {
        await dir.create(recursive: true);
        final filePath = '${dir.path}${Platform.pathSeparator}$fileName';
        final file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);
        return _SavedPayslipFile(path: filePath, locationLabel: label);
      } on FileSystemException {
        continue;
      }
    }

    throw FileSystemException('Tidak bisa menyimpan payslip');
  }

  Future<List<(Directory, String)>> _resolveSaveDirectories() async {
    final results = <(Directory, String)>[];

    if (Platform.isAndroid) {
      final downloadCandidates = <String>[
        '${Platform.pathSeparator}storage${Platform.pathSeparator}emulated${Platform.pathSeparator}0${Platform.pathSeparator}Download${Platform.pathSeparator}Staffku',
        '${Platform.pathSeparator}sdcard${Platform.pathSeparator}Download${Platform.pathSeparator}Staffku',
      ];
      for (final path in downloadCandidates) {
        try {
          final dir = Directory(path);
          results.add((dir, 'Download/Staffku'));
        } catch (_) {}
      }

      try {
        final ext = await getExternalStorageDirectory();
        if (ext != null) {
          results.add(
            (
              Directory('${ext.path}${Platform.pathSeparator}payslips'),
              'Penyimpanan aplikasi',
            ),
          );
        }
      } catch (_) {}
    }

    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) results.add((downloads, 'Download'));
    } catch (_) {}

    results.add((await _resolveAppPayslipsDirectory(), 'Dokumen aplikasi'));
    return results;
  }

  Future<Directory> _resolveAppPayslipsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final fallback = Directory(
      '${directory.path}${Platform.pathSeparator}payslips',
    );
    await fallback.create(recursive: true);
    return fallback;
  }

  @override
  void onClose() {
    periodeController.dispose();
    super.onClose();
  }
}
