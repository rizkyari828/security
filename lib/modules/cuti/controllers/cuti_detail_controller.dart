import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/cuti_sales/detail_request_cuti.dart';
import 'package:staffku/models/request/cuti_sales/update_approval_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staffku/models/response/cuti_sales/show_cuti_sales.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CutiDetailController extends GetxController {
  final ApiRepository apiRepository;
  CutiDetailController({required this.apiRepository});

  final argm = Get.arguments;
  var detail = ShowDataCutiSales().obs;
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
    getDetailCuti();
    loadUsers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    getDetailCuti();
    // getItemCnC();
    loadUsers();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
  }

  void getDetailCuti() async {
    final res = await apiRepository.showCutiSales(
      ShowCutiSalesRequest(id: argm.toString()),
    );
    final data = res?.data;
    if (data == null || data.isEmpty) {
      CommonWidget.errorSnackBar('Gagal memuat detail cuti');
      return;
    }
    detail.value = data.first;
    statusApproval.value = detail.value.statusCuti.toString().toLowerCase();
    String idRoleDetail = stringRoletoId(
      detail.value.levelApproval.toString().toLowerCase(),
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

  void approval({action = "reject"}) async {
    String id_action = '0';
    if (action == 'reject') {
      id_action = '0';
    } else {
      id_action = '1';
    }
    final res = await apiRepository.updateApprovalCutiSales(
      UpdateApprovalCutiSalesRequest(
        id: detail.value.idCuti.toString(),
        action: id_action,
        noteApproval: noteApprovalController.text,
      ),
    );
    if (res?.error == false) {
      getDetailCuti();
      loadUsers();
      EasyLoading.showSuccess('Berhasil disimpan');
    } else {
      EasyLoading.showError('Gagal disimpan');
    }
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
