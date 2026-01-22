import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/shift_swap/simpan_shift_request.dart';
import 'package:staffku/models/response/shift_swap/get_shift_response.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftSwapController extends BaseController {
  ShiftSwapController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final TextEditingController tglTukarController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  DateTime selectedTglTukar = DateTime.now();

  final RxList<ShiftOption> shiftOptions = <ShiftOption>[].obs;
  final Rxn<ShiftOption> selectedShift = Rxn<ShiftOption>();
  final RxBool isLoadingShiftOptions = false.obs;
  final formVersion = 0.obs;

  void markFormDirty() => formVersion.value++;

  bool get canSubmit {
    formVersion.value;
    return userId.value.trim().isNotEmpty &&
        tglTukarController.text.trim().isNotEmpty &&
        (selectedShift.value?.idShift != null) &&
        noteController.text.trim().isNotEmpty;
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
    markFormDirty();
  }

  SimpanShiftRequest buildRequest() {
    return SimpanShiftRequest(
      idShift: selectedShift.value?.idShift?.toString() ?? '',
      tanggal: tglTukarController.text.trim(),
      note: noteController.text.trim(),
      idUser: userId.value.trim(),
    );
  }

  Future<void> submit() async {
    showInputError.value = true;
    if (!canSubmit) {
      EasyLoading.showError('Semua field wajib diisi');
      return;
    }

    final res = await apiRepository.simpanShift(buildRequest());
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
    loadShiftOptions();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    userId.value = prefs.getString('userId') ?? '';
    groupId.value = prefs.getString('groupId') ?? '';
  }

  Future<void> loadShiftOptions() async {
    isLoadingShiftOptions.value = true;
    final res = await apiRepository.getShiftOptions();
    shiftOptions.assignAll(res?.data ?? []);
    isLoadingShiftOptions.value = false;
  }

  @override
  void onClose() {
    tglTukarController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
