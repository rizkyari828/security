import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/kuisioner/kuisioner_input_data_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staffku/models/response/kuisioner/input_data_kuisioner_respons.dart';
import 'package:staffku/models/response/kuisioner_response.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputDataKuisionerController extends BaseController {
  InputDataKuisionerController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final answerController = TextEditingController();

  final namaController = TextEditingController();
  final keteranganController = TextEditingController();

  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString placement = "".obs;
  RxString nameItem = "".obs;
  RxString idType = "".obs;
  RxString idUser = "".obs;
  RxString username = "".obs;
  RxString token = "".obs;

  DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  var listKuisioner = <DataKuisioner>[].obs;

  var dataSummaryKuisioner = DataSummaryKuisioner();

  Future<void> submitDataForm() async {
    final res = await apiRepository.submitDataKuisioner(
      KuisionerInputDataRequest(
        idUser: idUser.value,
        name: namaController.text,
        description: keteranganController.text,
      ),
    );
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      EasyLoading.dismiss();

      dataSummaryKuisioner.idTrans = res?.data?.first.idTrans;
      dataSummaryKuisioner.idGroup = res?.data?.first.idGroup;
      dataSummaryKuisioner.jumlahSoal = res?.data?.first.jumlahSoal;

      Get.toNamed(
        Routes.KUISIONER,
        arguments: {
          'id_kuisioner': dataSummaryKuisioner.idTrans,
          'id_group': dataSummaryKuisioner.idGroup,
          'total_question': dataSummaryKuisioner.jumlahSoal,
          'current_progress': 0,
          'page': 1,
          'limit': 2,
        },
      );
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

  @override
  void onClose() {
    super.onClose();
  }
}
