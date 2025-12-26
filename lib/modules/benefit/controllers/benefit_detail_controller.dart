import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/cuti/update_approval_request.dart';
import 'package:sales/models/response/benefit/show_benefit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BenefitDetailController extends GetxController {
  final ApiRepository apiRepository;
  BenefitDetailController({required this.apiRepository});

  final argm = Get.arguments;
  var detail = DataCuti().obs;
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
  RxString unitTypeName = "".obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString conditionLeave = "".obs;

  @override
  void onInit() {
    super.onInit();
    // getDetailCuti();
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
    loadUsers();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
    conditionLeave.value = prefs.getString('conditionLeave') ?? "";
  }

  void getDetailCuti() async {
    final res = await apiRepository.showCuti(argm.toString());
    final data = res?.data;
    if (data == null) {
      CommonWidget.errorSnackBar('Gagal memuat detail cuti');
      return;
    }
    detail.value = data;
    noRequestController.text = detail.value.code ?? '';
    noteController.text = detail.value.note ?? '';
    noteApprovalController.text = detail.value.noteApproval ?? '';
  }

  void approval({
    action = "reject",
  }) async {
    final res = await apiRepository.updateApprovalCuti(
        detail.value.id.toString(),
        UpdateApprovalCutiRequest(
          action: action,
          noteApproval: noteApprovalController.text,
        ));
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      getDetailCuti();
      loadUsers();
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

  selectDateGoods(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    dateGoods.value = selectedDate.toString();
  }

  void dateSubmit() {
    dateCnC.value = dateCnCController.text;
  }
}
