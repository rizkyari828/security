import 'package:intl/intl.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/prospek_v2/detail_request_cuti.dart';
import 'package:sales/models/request/prospek_v2/submit_request_prospek_v2.dart';
import 'package:sales/models/response/master_data_2_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sales/models/response/prospek_v2/detail_prospek_v2_response.dart';
import 'package:sales/modules/home/base_controller.dart';

class ProspekV2AddController extends BaseController {
  ProspekV2AddController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  String date = "";
  DateTime selectedDate = DateTime.now();
  final noteController = TextEditingController();

  RxInt idSource = 0.obs;
  RxInt idStatusProspect = 0.obs;
  RxInt idMediaCommunication = 0.obs;
  RxString idGender = ''.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString status = "".obs;
  RxString sourceOrderValue = "".obs;
  RxString statusProspectValue = "".obs;
  RxString mediaCommunicationValue = "".obs;
  RxString genderValue = "".obs;
  RxBool isFilled = true.obs;
  RxBool disabled = false.obs;
  RxInt minatProductId = 0.obs;
  RxString minatProduct = "".obs;
  var listMinatProduct = <MasterData2>[].obs;

  RxBool showInputError = false.obs;
  final prospectNameController = TextEditingController();
  final productNameController = TextEditingController();
  final dateLastUpdate = TextEditingController();
  final dateCalled = TextEditingController();
  final dateFu = TextEditingController();
  final noteCommunication = TextEditingController();
  final reasonNotOrder = TextEditingController();
  final otherProduct = TextEditingController();
  final totalTransaction = TextEditingController();
  final ageController = TextEditingController();
  var masterData = <MasterData2>[].obs;
  var listSourceOfOrder = <MasterData2>[].obs;
  var listMediaCommuncation = <MasterData2>[].obs;
  var listStatusProspect = <MasterData2>[].obs;
  var listGender = <MasterData2>[].obs;

  final argm = Get.arguments;
  var detail = ProspekDetailV2().obs;

  RxBool optionalTextOrder = false.obs;
  RxBool optionalTextProduk = false.obs;

  RxBool isEdit = false.obs;
  RxString statusBar = "Prospek".obs;

  var listStatusPekerjaan = <MasterData2>[].obs;
  RxString statusPekerjaan = "".obs;
  RxInt statusPekerjaanId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getMasterData();

    listGender.add(MasterData2(id: 1, nama: 'Laki-Laki', flag: 'gender'));
    listGender.add(MasterData2(id: 2, nama: 'Perempuan', flag: 'gender'));
  }

  @override
  void onReady() {
    super.onReady();

    if (argm != null) {
      getDetailProspek();
    }

    if (detail.value.statusProspectValue == 'Order') {
      statusBar.value = 'Order';
    }
  }

  void getDetailProspek() async {
    var argmLead = argm['data_lead'];
    print(argmLead.id);
    final res = await apiRepository
        .showProspekV2(ShowProspectV2Request(id: argmLead.id.toString()));
    detail.value = res?.data?.first ?? ProspekDetailV2();
    // detail.value = argm['data_lead'];
    if (detail.value.sourceOrderValue == 'tidak order') {
      optionalTextOrder.value = true;
    } else {
      optionalTextOrder.value = false;
    }

    prospectNameController.text = detail.value.prospectName ?? '';
    minatProduct.value = detail.value.productName ?? '';
    totalTransaction.text = detail.value.totalTransaction.toString();
    dateCalled.text = detail.value.dateCalled != null
        ? DateFormat('yyyy-MM-dd').format(detail.value.dateCalled!)
        : '';
    dateFu.text = detail.value.dateFu != null
        ? DateFormat('yyyy-MM-dd').format(detail.value.dateFu!)
        : '';
    noteCommunication.text = detail.value.noteCommunication ?? '';
    reasonNotOrder.text = detail.value.reasonNotOrder ?? '';
    dateLastUpdate.text = detail.value.dateLastUpdate ?? '';

    idStatusProspect.value = detail.value.idStatusProspect ?? 0;
    idMediaCommunication.value = detail.value.idMediaCommunication ?? 0;
    idSource.value = detail.value.idStatusOrder ?? 0;
    minatProductId.value = detail.value.idProduct ?? 0;

    statusProspectValue.value = detail.value.statusProspectValue ?? '';
    mediaCommunicationValue.value = detail.value.mediaCommunicationValue ?? '';
    sourceOrderValue.value = detail.value.sourceOrderValue ?? '';

    status.value = detail.value.statusProspectValue ?? '';
    statusPekerjaanId.value = int.parse(detail.value.statusPekerjaanId ?? '0');
    statusPekerjaan.value = detail.value.statusPekerjaanValue ?? '';

    ageController.text = detail.value.age ?? '';
    idGender.value = detail.value.gender ?? '';
    if (idGender.value == '') {
      genderValue.value = '';
    } else {
      if (idGender.value == 'L') {
        genderValue.value = 'Laki-Laki';
      } else {
        genderValue.value = 'Perempuan';
      }
    }

    // Disable input jika status tertentu
    if (detail.value.sourceOrderValue.toString().toLowerCase() ==
        "sudah order") {
      disabled.value = true;
    }

    isEdit.value = true;
  }

  selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    controller.text =
        DateFormat("yyyy-MM-dd", "id_ID").format(selectedDate).toString();
  }

  Future<void> selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        // Untuk memastikan tampilan 24 jam di beberapa device
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Format ke 24 jam: HH:mm
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = '$hour:$minute';
    }
  }

  void submitProspek() async {
    if (prospectNameController.text.isEmpty ||
        minatProductId.value == 0 ||
        totalTransaction.text.isEmpty ||
        idStatusProspect.value == 0 ||
        // dateCalled.text.isEmpty ||
        idMediaCommunication.value == 0 ||
        dateFu.text.isEmpty ||
        noteCommunication.text.isEmpty ||
        idSource.value == 0 ||
        genderValue.value == '' ||
        ageController.text.isEmpty ||
        statusPekerjaanId == 0) {
      showInputError.value = true;
      EasyLoading.showError('Semua field wajib diisi');
      return;
    }

    if (sourceOrderValue.value.toLowerCase() == 'tidak order') {
      if (reasonNotOrder.text.isEmpty) {
        showInputError.value = true;
        EasyLoading.showError('Semua field wajib diisi');
      }
    }

    if (minatProduct.value.toLowerCase() == 'others') {
      if (otherProduct.text.isEmpty) {
        showInputError.value = true;
        EasyLoading.showError('Semua field wajib diisi');
      }
    }

    final req = SubmitProspekV2Request(
        id: detail.value.id == null ? '0' : detail.value.id.toString(),
        userId: userId.value,
        prospectName: prospectNameController.text,
        idProductName: minatProductId.value.toString(),
        otherProduct: otherProduct.text,
        totalTransaction: totalTransaction.text,
        idStatusProspect: idStatusProspect.value.toString(),
        // dateCalled: dateCalled.text,
        idMediaCommunication: idMediaCommunication.value.toString(),
        dateFu: dateFu.text,
        noteCommunication: noteCommunication.text,
        statusOrder: idSource.value.toString(),
        reasonNotOrder: reasonNotOrder.text,
        idLead:
            detail.value.idLead == null ? '0' : detail.value.idLead.toString(),
        gender: idGender.value,
        age: ageController.text,
        statusPekerjaan: statusPekerjaanId.toString());

    final res = await apiRepository.submitProspectV2(req);

    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      Get.back(result: true);
    } else {
      EasyLoading.showError('Gagal disimpan');
    }
  }

  void getMasterData() async {
    masterData.clear();
    final resListLeadSource =
        await apiRepository.getMasterData2('Status Order');
    final statusOrderData = resListLeadSource?.data;
    if (statusOrderData != null) {
      masterData.value = statusOrderData;
    } else {
      masterData.clear();
    }
    for (var element in masterData) {
      listSourceOfOrder.add(element);
    }

    masterData.clear();
    final resListLeadCategory =
        await apiRepository.getMasterData2('Status Prospek');
    final statusProspekData = resListLeadCategory?.data;
    if (statusProspekData != null) {
      masterData.value = statusProspekData;
    } else {
      masterData.clear();
    }
    for (var element in masterData) {
      listStatusProspect.add(element);
    }

    masterData.clear();
    final resListStatusLead =
        await apiRepository.getMasterData2('Media Prospek');
    final mediaProspekData = resListStatusLead?.data;
    if (mediaProspekData != null) {
      masterData.value = mediaProspekData;
    } else {
      masterData.clear();
    }
    for (var element in masterData) {
      listMediaCommuncation.add(element);
    }

    masterData.clear();
    final resListMinatProduct =
        await apiRepository.getMasterData2('Produk', userId: userId.value);
    final produkData = resListMinatProduct?.data;
    if (produkData != null) {
      masterData.value = produkData;
    } else {
      masterData.clear();
    }
    for (var element in masterData) {
      listMinatProduct.add(element);
    }

    masterData.clear();
    final resListStatusPekerjaan =
        await apiRepository.getMasterData2('Status Kerja Leads');
    final statusPekerjaanData = resListStatusPekerjaan?.data;
    if (statusPekerjaanData != null) {
      masterData.value = statusPekerjaanData;
      for (var element in masterData) {
        listStatusPekerjaan.add(element);
      }
    }
  }

  void changeStatus(String value, String type) {
    if (type == 'produk') {
      if (value.toLowerCase() == 'tidak order') {
        optionalTextProduk.value = true;
      } else {
        optionalTextProduk.value = false;
      }
    } else if (type == 'gender') {
      if (value.toLowerCase() == 'laki-laki') {
        idGender.value = 'L';
      } else {
        idGender.value = 'P';
      }
    } else {
      if (value.toLowerCase() == 'tidak order') {
        optionalTextOrder.value = true;
      } else {
        optionalTextOrder.value = false;
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
