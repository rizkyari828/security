import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/shift_swap/approve_shift_request.dart';
import 'package:staffku/models/request/shift_swap/detail_shift_request.dart';
import 'package:staffku/models/response/shift_swap/detail_shift_response.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftSwapDetailController extends GetxController {
  final ApiRepository apiRepository;
  ShiftSwapDetailController({required this.apiRepository});

  final Rxn<DetailShiftItem> detail = Rxn<DetailShiftItem>();
  final RxBool isLoading = false.obs;

  final noteApprovalController = TextEditingController();

  RxString groupId = ''.obs;
  RxString statusApproval = ''.obs;
  RxBool approvalCondition = false.obs;

  final RxString status = ''.obs;
  final RxString nama = ''.obs;

  late final String id;

  @override
  void onReady() {
    super.onReady();
    _initArgs();
    _loadUsers().then((_) => fetchDetail());
  }

  void _initArgs() {
    final arg = Get.arguments;
    if (arg is Map) {
      id = (arg['id'] ?? '').toString();
      status.value = (arg['status'] ?? '').toString();
      nama.value = (arg['nama'] ?? '').toString();
      return;
    }
    id = (arg ?? '').toString();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    groupId.value = prefs.getString('groupId') ?? '';

    approvalCondition.value = groupId.value != '1';

    if (statusApproval.value.isEmpty && approvalCondition.value) {
      statusApproval.value = 'pengajuan';
    }
  }

  Future<void> fetchDetail() async {
    final idTrimmed = id.trim();
    if (idTrimmed.isEmpty) {
      CommonWidget.errorSnackBar('ID tukar shift tidak ditemukan');
      return;
    }

    isLoading.value = true;
    final incomingStatus = status.value.trim();
    if (incomingStatus.isNotEmpty) {
      statusApproval.value = incomingStatus.toLowerCase().trim();
    } else if (statusApproval.value.isEmpty && approvalCondition.value) {
      statusApproval.value = 'pengajuan';
    }

    final res = await apiRepository.detailShift(
      DetailShiftRequest(id: idTrimmed),
    );
    final data = res?.data;
    if (data == null || data.isEmpty) {
      isLoading.value = false;
      CommonWidget.errorSnackBar('Gagal memuat detail tukar shift');
      return;
    }

    detail.value = data.first;
    isLoading.value = false;
  }

  void approval({action = 'reject'}) async {
    final item = detail.value;
    if (item == null) return;

    var idAction = '0';
    if (action != 'reject') {
      idAction = '1';
    }

    final res = await apiRepository.approveShift(
      ApproveShiftRequest(
        id: id.trim(),
        sts: idAction,
        note: noteApprovalController.text.trim(),
      ),
    );

    if (res?.error == false) {
      final newStatus = idAction == '1' ? 'Disetujui' : 'Ditolak';
      status.value = newStatus;
      statusApproval.value = newStatus.toLowerCase();
      detail.value = item.copyWith(
        noteTolak: noteApprovalController.text.trim(),
      );

      EasyLoading.showSuccess(res?.message ?? 'Berhasil disimpan');
      return;
    }

    EasyLoading.showError(res?.message ?? 'Gagal disimpan');
  }

  @override
  void onClose() {
    noteApprovalController.dispose();
    super.onClose();
  }
}
