import 'package:sales/api/api_repository.dart';
import 'package:sales/models/action.dart';
import 'package:sales/models/request/overtime/get_list.dart';
import 'package:sales/models/request/overtime/update_approval_overtime_request.dart';
import 'package:sales/models/response/prospek/master_data_response.dart';
import 'package:sales/models/response/prospek/master_id_response.dart';
import 'package:sales/models/response/prospek/master_status_response.dart';
import 'package:sales/models/response/prospek/show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sales/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/utils/common_widget.dart';

class ProspekDetailController extends GetxController {
  final ApiRepository apiRepository;
  ProspekDetailController({required this.apiRepository});

  final argm = Get.arguments;
  var detail = ProspekDetail().obs;
  var masterData = <MasterData>[].obs;
  var masterStatus = <MasterStatus>[].obs;
  var masterId = <MasterId>[].obs;

  var listAction = <ActionStatus>[].obs;
  var listType = <ActionStatus>[].obs;
  var listActivity = <MasterData>[].obs;
  var listReasonCancle = <MasterData>[].obs;
  var listReasonReject = <MasterData>[].obs;
  var listSourceOfOrder = <MasterData>[].obs;
  var listStatusOrder = <MasterStatus>[].obs;

  var arrayFive = <double>[
    0.5,
    1.0,
  ].obs;
  String date = "";
  DateTime selectedDate = DateTime.now();
  final noRequestController = TextEditingController();
  final noteController = TextEditingController();
  final approvalController = TextEditingController();
  final namaRoomController = TextEditingController();
  final actualTimeController = TextEditingController();
  final nicknameController = TextEditingController();
  final sourceController = TextEditingController();
  final typeController = TextEditingController();
  final vehicleType = TextEditingController();
  final keterangan = TextEditingController();
  RxString nameItem = "".obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString conditionOvertime = "".obs;
  RxString actionStatus = "".obs;
  RxString status = "".obs;
  RxString activity = "".obs;
  RxString action = "".obs;
  RxString source = "".obs;
  RxString reason = "".obs;
  RxString token = "".obs;
  RxBool isFilled = true.obs;
  RxBool disabled = false.obs;
  RxBool enabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    // getDetailOvertime();
  }

  @override
  void onReady() {
    super.onReady();
    getDetailProspek();
    loadUsers();
    loadMaster();

    listType.add(ActionStatus(
      id: "2",
      name: "Mobil",
    ));
    listType.add(ActionStatus(
      id: "1",
      name: "Motor",
    ));
    listAction.add(ActionStatus(
      id: "",
      name: "Accepted",
    ));
    listAction.add(ActionStatus(
      id: "4",
      name: "Cancel",
    ));
    listAction.add(ActionStatus(
      id: "5",
      name: "Reject",
    ));
    listAction.add(ActionStatus(
      id: "6",
      name: "TBC",
    ));
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    getDetailProspek();
    loadUsers();
  }

  void loadMaster() {
    getMasterDataProspek();
    getMasterStatusProspek();
    getMasteIdProspek();
  }

  void getMasterDataProspek() async {
    final res = await apiRepository.getMasterData();
    final data = res?.data;
    if (data == null || data.isEmpty) return;

    masterData.value = data;
    for (var element in masterData) {
      if (element.flag == "1") {
        listSourceOfOrder.add(element);
      } else if (element.flag == "2") {
        listActivity.add(element);
      } else if (element.flag == "3") {
        listReasonCancle.add(element);
      } else if (element.flag == "4") {
        listReasonReject.add(element);
      }
    }
  }

  void getMasterStatusProspek() async {
    final res = await apiRepository.getMasterStatus();
    final data = res?.data;
    if (data == null || data.isEmpty) return;

    masterStatus.value = data;
    // for (var element in masterStatus) {
    listStatusOrder.addAll(data);
    // }
  }

  void getMasteIdProspek() async {
    final res = await apiRepository.getMasterIdProspek();
    final data = res?.data;
    if (data == null || data.isEmpty) return;

    masterId.value = data;
  }

  void submit() async {
    EasyLoading.show(status: 'loading..');

    // final res = await apiRepository.setDoneOvertime(argm,
    //     setdone.SetDoneOvertimeRequest(overtimeRoomPhotos: dokumentRoom.value));
    // if (res?.error == false) {
    //   EasyLoading.showSuccess('Berhasil disimpan');
    //   Get.back();
    //   EasyLoading.dismiss();
    // } else {
    //   EasyLoading.showError('Gagal disimpan');
    //   EasyLoading.dismiss();
    // }
  }

  void approval({
    action = "reject",
  }) async {
    int _statusId = 0;
    int _actionId = 0;
    int _typeId = 0;
    for (var action in listAction) {
      if (action.name == actionStatus.value) {
        if (actionStatus.value == "Accepted") {
          _statusId = 1;
        } else {
          _statusId = int.parse(action.id ?? '0');
        }
      }
    }
    for (var types in listType) {
      if (types.name == typeController.text) {
        if (actionStatus.value != "Accepted") {
          _typeId = 0;
        } else {
          _typeId = int.parse(types.id ?? '0');
        }
      }
    }

    if (actionStatus.value == 'Cancle') {
      for (var reasonL in listReasonCancle) {
        if (reasonL.nama == reason.value) {
          _actionId = reasonL.id ?? 0;
        }
      }
    } else if (actionStatus.value == 'Reject') {
      for (var reasonLR in listReasonReject) {
        if (reasonLR.nama == reason.value) {
          _actionId = reasonLR.id ?? 0;
        }
      }
    } else {
      _actionId = 0;
    }

    final res = await apiRepository.updateApprovalOvertime(
      detail.value.id.toString(),
      UpdateApprovalOvertimeRequest(
          action: _actionId,
          noTrans: detail.value.noTrans,
          status: _statusId,
          kunci: token.value,
          note: noteController.text,
          type: _typeId),
    );

    if (res?.error == false) {
      getDetailProspek();
      loadUsers();
      actionStatus.value = '';
      EasyLoading.showSuccess('Berhasil disimpan');
      _dialogSuccess();
    } else {
      EasyLoading.showError('Gagal disimpan');
    }
  }

  void _dialogSuccess() {
    Get.defaultDialog(
      title: "Informasi",
      content: CommonWidget.bodyText(
        text: "Data berhasil disimpan",
      ),
      textConfirm: 'OK',
      onConfirm: () {
        Get.back();
      },
    );
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
    token.value = prefs.getString('token') ?? "";
    conditionOvertime.value = prefs.getString('conditionOvertime') ?? "";
  }

  void getDetailProspek() async {
    final res = await apiRepository.showProspek(
        argm.toString(), GetListRequest(id: '0', token: ''));
    final data = res?.data;
    if (data == null || data.isEmpty) {
      CommonWidget.errorSnackBar('Gagal memuat detail prospek');
      detail.value = ProspekDetail();
      return;
    }
    detail.value = data.first;
    noRequestController.text = detail.value.noTrans ?? '';
    nicknameController.text = detail.value.nama ?? '';
    sourceController.text = detail.value.source ?? '';
    vehicleType.text = detail.value.vehicleType ?? '';
    // noteController.text = detail.value. ?? '';
    // actualTimeController.text = detail.value.actualTime ?? '';
    keterangan.text = detail.value.keterangan ?? '';
    noteController.text = detail.value.reason ?? '';
    status.value = detail.value.namaCat ?? '';

    if (detail.value.status == "3" ||
        detail.value.status == "4" ||
        detail.value.status == "5") {
      disabled.value = true;
      enabled.value = false;
    }
  }

  void checkValidation(int list) {
    if (namaRoomController.text == '') {
      isFilled.value = false;
    } else {
      isFilled.value = true;
    }
  }

  void changeStatus() {
    reason.value = '';
    // status.value = actionStatus.value == 'Booking'
    //     ? 'Order'
    //     : actionStatus.value == 'Reject'
    //         ? 'Backlog'
    //         : actionStatus.value == 'Follow Up'
    //             ? 'Prospek'
    //             : '';
  }

  void goToDetailPages({String id = ""}) {
    Get.toNamed(Routes.DETAIL_PROSPEK, arguments: id);
  }
}
