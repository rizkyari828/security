import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/claim/submit_claim_request.dart';
import 'package:sales/modules/home/base_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimController extends BaseController {
  ClaimController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  final TextEditingController tanggalClaimController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();

  DateTime selectedTanggalClaim = DateTime.now();

  bool get canSubmit {
    return userId.value.trim().isNotEmpty &&
        tanggalClaimController.text.trim().isNotEmpty &&
        nominalController.text.trim().isNotEmpty &&
        keteranganController.text.trim().isNotEmpty;
  }

  Future<void> selectTanggalClaim(BuildContext context) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1, 1, 1),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDate: selectedTanggalClaim,
    );
    if (selected == null) return;
    selectedTanggalClaim = selected;
    tanggalClaimController.text =
        DateFormat('yyyy-MM-dd', 'id_ID').format(selected);
  }

  SubmitClaimRequest buildRequest() {
    return SubmitClaimRequest(
      idUser: userId.value.trim(),
      tanggalClaim: tanggalClaimController.text.trim(),
      nominal: nominalController.text.trim(),
      keterangan: keteranganController.text.trim(),
    );
  }

  Future<void> submit() async {
    showInputError.value = true;
    if (!canSubmit) {
      EasyLoading.showError('Semua field wajib diisi');
      return;
    }

    final res = await apiRepository.submitClaim(buildRequest());
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
    tanggalClaimController.dispose();
    nominalController.dispose();
    keteranganController.dispose();
    super.onClose();
  }
}

