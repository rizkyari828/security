import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/detail_request.dart';
import 'package:sales/models/response/reliver/show_reliver_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReliverDetailController extends GetxController {
  final ApiRepository apiRepository;
  ReliverDetailController({required this.apiRepository});

  final argm = Get.arguments;
  var detail = DataShowReliver().obs;
  String date = "";
  DateTime selectedDate = DateTime.now();
  final noRequestController = TextEditingController();
  final noteController = TextEditingController();
  final noteApprovalController = TextEditingController();
  final qtyController = TextEditingController();
  final dateStartWorkController = TextEditingController();
  final TextEditingController numberReliver = TextEditingController();
  RxString groupName = "".obs;
  RxString groupId = "".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getDetail();
    loadUsers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    getDetail();
    loadUsers();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
  }

  void getDetail() async {
    final res =
        await apiRepository.showReliver(ShowEventRequest(id: argm.toString()));
    final data = res?.data;
    if (data == null || data.isEmpty) {
      CommonWidget.errorSnackBar('Gagal memuat detail event');
      return;
    }
    detail.value = data.first;
  }

  void approval({
    action = "reject",
  }) async {
    // final res = await apiRepository.updateApprovalReliver(
    //     detail.value.id.toString(),
    //     ApproveReliverRequest(
    //       action: action,
    //       needAprroveEmployee: int.parse(numberReliver.text),
    //       dateStartWorkEmployee: dateStartWorkController.text,
    //       noteApproval: noteApprovalController.text,
    //     ));
    // if (res?.error == false) {
    //   EasyLoading.showSuccess('Berhasil disimpan');
    //   getDetail();
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
    dateStartWorkController.text =
        DateFormat("yyyy-MM-dd", "id_ID").format(selectedDate).toString();
  }
}
