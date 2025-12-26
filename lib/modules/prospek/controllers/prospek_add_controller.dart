import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/overtime/submit_request_overtime.dart';
import 'package:sales/models/response/prospek/master_data_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProspekAddController extends GetxController {
  final ApiRepository apiRepository;
  ProspekAddController({required this.apiRepository});

  String date = "";
  DateTime selectedDate = DateTime.now();
  final noteController = TextEditingController();
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;
  RxInt idUser = 0.obs;
  RxInt idSource = 0.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  final nickname = TextEditingController();

  var masterData = <MasterData>[].obs;
  var listSourceOfOrder = <MasterData>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();
    loadMaster();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
    token.value = prefs.getString('token') ?? "";
    userId.value = prefs.getString('userId') ?? "";
    latitude.value = prefs.getDouble('initLatitude') ?? 0.0;
    longitude.value = prefs.getDouble('initLongitude') ?? 0.0;
  }

  void submitProspek() async {
    final res = await apiRepository.submitOvertime(
      SubmitOvertimeRequest(
          userId: int.parse(userId.value),
          name: nickname.text,
          sourceId: idSource.value,
          token: token.value,
          latitude: latitude.value.toString(),
          longitude: longitude.value.toString(),
          note: noteController.text),
    );

    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      Get.back();
    } else {
      EasyLoading.showError('Gagal disimpan');
    }
  }

  void loadMaster() {
    getMasterDataProspek();
  }

  void getMasterDataProspek() async {
    final res = await apiRepository.getMasterData();
    final data = res?.data;
    if (data == null || data.isEmpty) return;

    masterData.value = data;
    for (var element in masterData) {
      if (element.flag == "1") {
        listSourceOfOrder.add(element);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
