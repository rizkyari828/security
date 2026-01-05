import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/shift_swap/submit_shift_swap_request.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftSwapController extends BaseController {
  ShiftSwapController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final TextEditingController tglTukarController = TextEditingController();
  final TextEditingController userIdPenggantiController =
      TextEditingController();

  final RxString shiftTukar = ''.obs;
  DateTime selectedTglTukar = DateTime.now();

  final List<String> shiftOptions = const ['Pagi', 'Siang', 'Malam'];

  bool get canSubmit {
    return userId.value.trim().isNotEmpty &&
        tglTukarController.text.trim().isNotEmpty &&
        shiftTukar.value.isNotEmpty &&
        userIdPenggantiController.text.trim().isNotEmpty;
  }

  Future<void> selectTglTukar(BuildContext context) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDate: selectedTglTukar,
    );
    if (selected == null) return;
    selectedTglTukar = selected;
    tglTukarController.text = DateFormat(
      'yyyy-MM-dd',
      'id_ID',
    ).format(selected);
  }

  SubmitShiftSwapRequest buildRequest() {
    return SubmitShiftSwapRequest(
      userId: userId.value.trim(),
      tanggalTukar: tglTukarController.text.trim(),
      shiftTukar: shiftTukar.value,
      userIdPengganti: userIdPenggantiController.text.trim(),
    );
  }

  Future<void> submit() async {
    showInputError.value = true;
    if (!canSubmit) {
      EasyLoading.showError('Semua field wajib diisi');
      return;
    }

    final res = await apiRepository.submitShiftSwap(buildRequest());
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      EasyLoading.dismiss();
      Get.back(result: true);
    } else {
      EasyLoading.showError(res?.message ?? 'Gagal disimpan');
      EasyLoading.dismiss();
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
    tglTukarController.dispose();
    userIdPenggantiController.dispose();
    super.onClose();
  }
}
