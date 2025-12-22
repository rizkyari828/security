import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales/models/request/shift_swap/submit_shift_swap_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftSwapController extends GetxController {
  final RxBool showInputError = false.obs;

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController tglTukarController = TextEditingController();
  final TextEditingController userIdPenggantiController =
      TextEditingController();

  final RxString shiftTukar = ''.obs;
  DateTime? selectedTglTukar;

  final List<String> shiftOptions = const [
    'Pagi',
    'Siang',
    'Malam',
  ];

  @override
  void onInit() {
    super.onInit();
    final prefs = Get.find<SharedPreferences>();
    userIdController.text = prefs.getString('userId') ?? '';
  }

  bool get canSubmit {
    return userIdController.text.trim().isNotEmpty &&
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
      initialDate: selectedTglTukar ?? now,
    );
    if (selected == null) return;
    selectedTglTukar = selected;
    tglTukarController.text = DateFormat('yyyy-MM-dd').format(selected);
  }

  SubmitShiftSwapRequest buildRequest() {
    return SubmitShiftSwapRequest(
      userId: userIdController.text.trim(),
      tanggalTukar: tglTukarController.text.trim(),
      shiftTukar: shiftTukar.value,
      userIdPengganti: userIdPenggantiController.text.trim(),
    );
  }

  void submitDraft() {
    showInputError.value = true;
    if (!canSubmit) return;
    final req = buildRequest();
    Get.snackbar(
      'Draft',
      'Request siap dikirim (belum ada API).\n'
          'user_id=${req.userId}, tgl_tukar=${req.tanggalTukar}, shift_tukar=${req.shiftTukar}, user_id_pengganti=${req.userIdPengganti}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    userIdController.dispose();
    tglTukarController.dispose();
    userIdPenggantiController.dispose();
    super.onClose();
  }
}
