import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/cuti/submit_cuti_request.dart';
import 'package:sales/models/response/benefit/type_cuti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BenefitAddController extends GetxController {
  final ApiRepository apiRepository;
  BenefitAddController({required this.apiRepository});

  String date = "";
  DateTime selectedDate = DateTime.now();
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final dateController = TextEditingController();
  final dateCnCController = TextEditingController();
  RxString dateStart = "".obs;
  RxString dateGoods = "".obs;
  RxString nameItem = "".obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString placement = "".obs;
  var listType = <DataTypeCuti>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();
    getType();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
    placement.value = prefs.getString('placement') ?? "";
  }

  selectDateStart(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    startDateController.text =
        DateFormat("yyyy-MM-dd", "id_ID").format(selectedDate).toString();
  }

  selectDateEnd(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    endDateController.text =
        DateFormat("yyyy-MM-dd", "id_ID").format(selectedDate).toString();
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

  // void dateSubmit() {
  //   dateCnC.value = dateCnCController.text;
  // }

  void submit() async {
    final res = await apiRepository.submitCuti(
      SubmitCutiRequest(
          dateStart: startDateController.text,
          dateEnd: endDateController.text,
          note: noteController.text,
          leaveTypeId: nameItem.value),
    );
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      Get.back();
    } else {
      EasyLoading.showError(res?.message ?? 'Gagal disimpan');
    }
  }

  void getType() async {
    final res = await apiRepository.typeCuti();
    listType.addAll(res?.data ?? []);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
