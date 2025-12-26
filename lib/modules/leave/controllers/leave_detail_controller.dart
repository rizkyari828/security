import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/detail_request_leave.dart';
import 'package:sales/models/request/izin/update_approval_request.dart';
import 'package:sales/models/response/izin/show_izin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/modules/home/base_controller.dart';
import 'package:sales/shared/utils/common_widget.dart';
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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getDetailIzin();
    loadUsers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    getDetailIzin();
    // getItemCnC();
    loadUsers();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
  }

  void getDetailIzin() async {
    final res =
        await apiRepository.showIzin(ShowLeaveRequest(id: argm.toString()));
    final data = res?.data;
    if (data == null || data.isEmpty) {
      CommonWidget.errorSnackBar('Gagal memuat detail izin');
      return;
    }
    detail.value = data.first;
  }

  void approval({
    action = "reject",
  }) async {
    await apiRepository.updateApprovalIzin(
        detail.value.id.toString(),
        UpdateApprovalIzinRequest(
          action: action,
          noteApproval: noteApprovalController.text,
        ));
    // if (res?.error == false) {
    //   EasyLoading.showSuccess('Berhasil disimpan');
    //   getDetailIzin();
    //   loadUsers();
    // } else {
    //   EasyLoading.showError('Gagal disimpan');
    // }
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
