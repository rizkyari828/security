import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/claim/detail_claim_request.dart';
import 'package:staffku/models/request/claim/update_approval_claim_request.dart';
import 'package:staffku/models/response/claim/show_claim_response.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimDetailController extends GetxController {
  final ApiRepository apiRepository;
  ClaimDetailController({required this.apiRepository});

  final argm = Get.arguments;
  var detail = ShowClaimItem().obs;

  final noteApprovalController = TextEditingController();
  RxString groupId = ''.obs;
  RxString statusApproval = ''.obs;
  RxBool approvalCondition = false.obs;

  @override
  void onReady() {
    super.onReady();
    getDetailClaim();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    groupId.value = prefs.getString('groupId') ?? '';
  }

  Future<void> onRefresh() async {
    getDetailClaim();
    _loadUsers();
  }

  void getDetailClaim() async {
    final res = await apiRepository.showClaim(
      ShowClaimRequest(id: argm.toString()),
    );
    final data = res?.data;
    if (data == null || data.isEmpty) {
      CommonWidget.errorSnackBar('Gagal memuat detail claim');
      return;
    }
    detail.value = data.first;
    statusApproval.value = (detail.value.statusClaim ?? '').toLowerCase();
    final idRoleDetail = stringRoletoId(
      (detail.value.levelApproval ?? '').toLowerCase(),
    );
    approvalCondition.value = idRoleDetail == groupId.value;
  }

  String stringRoletoId(String role) {
    switch (role.toLowerCase()) {
      case 'staff':
        return '1';
      case 'spv':
        return '2';
      // case 'area':
      //   return '3';
      // case 'client':
      //   return '4';
      default:
        return '1';
    }
  }

  void approval({action = 'reject'}) async {
    var idAction = '0';
    if (action != 'reject') {
      idAction = '1';
    }
    final res = await apiRepository.updateApprovalClaim(
      UpdateApprovalClaimRequest(
        id: detail.value.idClaim?.toString() ?? '',
        action: idAction,
        noteApproval: noteApprovalController.text,
      ),
    );
    if (res?.error == false) {
      getDetailClaim();
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
