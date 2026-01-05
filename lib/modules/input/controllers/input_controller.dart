import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/input_request.dart';
import 'package:staffku/models/response/izin/type_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputController extends GetxController {
  final ApiRepository apiRepository;
  InputController({required this.apiRepository});

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final totalBahanCRM = TextEditingController();
  final jumlahFuWalk = TextEditingController();
  final jumlahFuCRM = TextEditingController();
  final jumahBerminat = TextEditingController();
  final jumlahPikirPikir = TextEditingController();
  final jumlahBelumBerminat = TextEditingController();
  final jumlahTidakBisaDihubungi = TextEditingController();
  final jumlah3n = TextEditingController();
  final jumlahOrder = TextEditingController();
  final jumlahMCY = TextEditingController();
  final jumlahCAR = TextEditingController();
  final totalMCYCAR = TextEditingController();
  final totalMCY = TextEditingController();
  final totalCAR = TextEditingController();
  final nipAdira = TextEditingController();

  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString placement = "".obs;
  RxString nameItem = "".obs;
  RxString idType = "".obs;
  RxString idUser = "".obs;
  RxString username = "".obs;
  RxString token = "".obs;

  String date = "";
  DateTime selectedDate = DateTime.now();
  RxString dateCnC = "".obs;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  RxString validationDate = "".obs;
  var listType = <DataTypeIzin>[].obs;

  void submit() {
    if (endDate.compareTo(startDate) >= 0) {
      submitData();
    } else {
      validationDate.value =
          'Tanggal selesai tidak bisa lebih besar dari tanggal mulai';
    }
  }

  void submitData() async {
    final res = await apiRepository.submitInput(
      SubmitInputRequest(
        idUser: username.value,
        token: token.value,
        nipAdira: nipAdira.text,
        totalBahanCRM: int.parse(totalBahanCRM.text),
        jumlahFuWalk: int.parse(jumlahFuWalk.text),
        jumlahFuCRM: int.parse(jumlahFuCRM.text),
        jumahBerminat: int.parse(jumahBerminat.text),
        jumlahPikirPikir: int.parse(jumlahPikirPikir.text),
        jumlahBelumBerminat: int.parse(jumlahBelumBerminat.text),
        jumlahTidakBisaDihubungi: int.parse(jumlahTidakBisaDihubungi.text),
        jumlah3n: int.parse(jumlah3n.text),
        jumlahOrder: int.parse(jumlahOrder.text),
        jumlahMCY: int.parse(jumlahMCY.text),
        totalMCYCAR: int.parse(totalMCYCAR.text),
        jumlahCAR: int.parse(jumlahCAR.text),
        totalMCY: int.parse(totalMCY.text),
        totalCAR: int.parse(totalCAR.text),
      ),
    );
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      EasyLoading.dismiss();
      Get.back();
    } else {
      EasyLoading.showError('Gagal disimpan');
      EasyLoading.dismiss();
    }
  }

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
    token.value = prefs.getString('token') ?? "";
    idUser.value = prefs.getString('userId') ?? "";
    username.value = prefs.getString('username') ?? "";
  }

  selectDateStart(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    startDate = selectedDate;
    startDateController.text = DateFormat(
      "yyyy-MM-dd",
      "id_ID",
    ).format(selectedDate).toString();
  }

  selectDateEnd(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    endDate = selectedDate;
    endDateController.text = DateFormat(
      "yyyy-MM-dd",
      "id_ID",
    ).format(selectedDate).toString();
  }

  void getType() async {
    final res = await apiRepository.typeIzin();
    listType.addAll(res?.data ?? []);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
