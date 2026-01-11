import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/shift_swap/detail_shift_swap_request.dart';
import 'package:staffku/models/request/shift_swap/update_approval_shift_swap_request.dart';
import 'package:staffku/models/response/shift_swap/show_shift_swap_response.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftSwapDetailController extends GetxController {
  final ApiRepository apiRepository;
  ShiftSwapDetailController({required this.apiRepository});

  final argm = Get.arguments;
  var detail = ShowShiftSwapItem().obs;

  final noteApprovalController = TextEditingController();

  RxString groupId = ''.obs;
  RxString statusApproval = ''.obs;
  RxBool approvalCondition = false.obs;

  @override
  void onReady() {
    super.onReady();
    _loadUsers().then((_) => getDetailShiftSwap());
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    groupId.value = prefs.getString('groupId') ?? '';
  }

  Future<void> onRefresh() async {
    await _loadUsers();
    getDetailShiftSwap();
  }

  void getDetailShiftSwap() async {
    final res = await apiRepository.showShiftSwap(
      ShowShiftSwapRequest(id: argm.toString()),
    );
    final data = res?.data;
    if (data == null || data.isEmpty) {
      CommonWidget.errorSnackBar('Gagal memuat detail tukar shift');
      return;
    }
    detail.value = data.first;
    statusApproval.value = (detail.value.statusTukar ?? '').toLowerCase();
    final idRoleDetail = stringRoletoId(
      (detail.value.levelApproval ?? '').toLowerCase(),
    );
    approvalCondition.value = idRoleDetail == groupId.value;
  }

  String stringRoletoId(String role) {
    final normalized = role.toLowerCase().trim();
    switch (normalized) {
      case '1':
      case 'staff':
        return '1';
      case '2':
      case 'spv':
      case 'cabang':
      case 'branch':
        return '2';
      case '3':
      case 'area':
        return '3';
      case '4':
      case 'client':
        return '4';
      default:
        final numeric = int.tryParse(normalized);
        if (numeric != null) return normalized;
        return '1';
    }
  }

  void approval({action = 'reject'}) async {
    var idAction = '0';
    if (action != 'reject') {
      idAction = '1';
    }
    final res = await apiRepository.updateApprovalShiftSwap(
      UpdateApprovalShiftSwapRequest(
        id: detail.value.idTukarShift?.toString() ?? '',
        action: idAction,
        noteApproval: noteApprovalController.text,
      ),
    );
    if (res?.error == false) {
      getDetailShiftSwap();
      _loadUsers();
      EasyLoading.showSuccess('Berhasil disimpan');
    } else {
      EasyLoading.showError('Gagal disimpan');
    }
  }

  @override
  void onClose() {
    noteApprovalController.dispose();
    super.onClose();
  }
}
