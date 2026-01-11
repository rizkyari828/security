import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/detail_request_leave.dart';
import 'package:staffku/models/request/izin/update_approval_request.dart';
import 'package:staffku/models/response/izin/show_izin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveDetailController extends BaseController {
  LeaveDetailController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final argm = Get.arguments;
  var detail = DataIzin().obs;
  String date = "";
  DateTime selectedDate = DateTime.now();
  final noRequestController = TextEditingController();
  final noteController = TextEditingController();
  final noteApprovalController = TextEditingController();
  final qtyController = TextEditingController();
  final dateController = TextEditingController();
  final dateCnCController = TextEditingController();
  RxString dateCnC = "".obs;
  RxString dateGoods = "".obs;
  RxString nameItem = "".obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString statusApproval = "".obs;
  RxBool approvalCondition = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers().then((_) => getDetailIzin());
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    await loadUsers();
    getDetailIzin();
  }

  Future<void> loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
  }

  void getDetailIzin() async {
    final res = await apiRepository.showIzin(
      ShowLeaveRequest(id: argm.toString()),
    );
    final data = res?.data;
    if (data == null || data.isEmpty) {
      CommonWidget.errorSnackBar('Gagal memuat detail izin');
      return;
    }
    detail.value = data.first;

    final status = (detail.value.statusIjin ?? '').trim();
    statusApproval.value = status.toLowerCase();

    final level = (detail.value.levelApproval ?? '').trim();
    if (level.isNotEmpty) {
      final idRoleDetail = stringRoletoId(level);
      approvalCondition.value = idRoleDetail == groupId.value;
    } else {
      approvalCondition.value = groupId.value != '1';
    }

    if (statusApproval.value.isEmpty && approvalCondition.value) {
      statusApproval.value = 'pengajuan';
    }
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

  void approval({action = "reject"}) async {
    final res = await apiRepository.updateApprovalIzin(
      detail.value.id.toString(),
      UpdateApprovalIzinRequest(
        action: action,
        noteApproval: noteApprovalController.text,
      ),
    );
    if (res?.error == false) {
      EasyLoading.showSuccess(res?.message ?? 'Berhasil disimpan');
      getDetailIzin();
      return;
    }

    EasyLoading.showError(res?.message ?? 'Gagal disimpan');
  }

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    dateCnC.value = selectedDate.toString();
  }

  void dateSubmit() {
    dateCnC.value = dateCnCController.text;
  }

  void updateGoods({name}) {
    // goods.removeWhere((e) => e.id == id);
    // goods[goods.indexWhere((element) => element.name == name)] = singleGoods;
  }

  void deleteGoods({name}) {}
}
