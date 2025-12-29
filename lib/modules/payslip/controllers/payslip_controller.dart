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
    if (userId.value.trim().isEmpty) {
      EasyLoading.showError('User tidak valid');
      return;
    }
    if (isDownloading.value) return;

    final month = selectedPeriode.value.month.toString().padLeft(2, '0');
    final year = selectedPeriode.value.year.toString();

    isDownloading.value = true;
    EasyLoading.show(status: 'Mengunduh payslip...');
    try {
      final result = await apiRepository.downloadPayslipExcel(
        DownloadPayslipRequest(
          userId: userId.value,
          month: month,
          year: year,
        ),
      );
      if (result == null) return;

      final fileName = _sanitizeFilename(
        result.filename ?? 'payslip_${year}_$month.xlsx',
      );
      final directory = await getApplicationDocumentsDirectory();
      final payslipDirPath =
          '${directory.path}${Platform.pathSeparator}payslips';
      await Directory(payslipDirPath).create(recursive: true);
      final filePath = '$payslipDirPath${Platform.pathSeparator}$fileName';

      final file = File(filePath);
      await file.writeAsBytes(result.bytes, flush: true);
      lastSavedPath.value = filePath;

      EasyLoading.showSuccess('Payslip tersimpan');
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
    return cleaned.isEmpty ? 'payslip.xlsx' : cleaned;
  }

  @override
  void onClose() {
    periodeController.dispose();
    super.onClose();
  }
}

