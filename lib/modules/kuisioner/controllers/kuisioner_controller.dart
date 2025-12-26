import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/attendance/attendance_wrapper.dart';
import 'package:sales/models/request/kuisioner/kuisioner_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales/models/request/pagination_request.dart';
import 'package:sales/models/response/kuisioner_response.dart';
import 'package:sales/modules/home/base_controller.dart';
import 'package:sales/routes/app_pages.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/utils/size_config.dart';
import 'package:sales/shared/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KusionerController extends BaseController {
  KusionerController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  var imageFileList = <XFile>[].obs;

  final ImagePicker _picker = ImagePicker();

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final answerController = TextEditingController();

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

  RxInt page = 1.obs;

  RxString validationDate = "".obs;
  var listKuisioner = <DataKuisioner>[].obs;
  var submitKuisioner = <SubmitKuisioner>[].obs;

  final selectedAnswer = ''.obs;

  dynamic pickImageError;
  RxString? retrieveDataError;

  // Tambahkan penampung jawaban
  var answers = <String, String>{}.obs; // key: idSoal, value: jawaban

  // Tambahkan map untuk essayControllers
  final Map<String, TextEditingController> essayControllers = {};

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final argm = Get.arguments;

  RxInt currentProgress = 0.obs;
  RxInt allProgress = 0.obs;
  RxInt idKuisioner = 0.obs;
  RxDouble percentage = 0.0.obs;
  RxInt idGroupKuisioner = 0.obs;

  var jawabanList = <JawabanKuisioner>[].obs;

  void setAnswer(String idSoal, String idKategori, String jawaban) {
    // Update ke answers agar UI sinkron
    answers[idSoal] = jawaban;
    // Jika ingin update selectedAnswer untuk radio, bisa juga:
    selectedAnswer.value = jawaban;
    // Update ke jawabanList jika memang masih dipakai
    final idx = jawabanList.indexWhere((e) => e.idSoal == idSoal);
    if (idx != -1) {
      jawabanList[idx].jawaban = jawaban;
      jawabanList.refresh();
    }
  }

  var imageFileMap = <String, List<XFile>>{}.obs; // key: idSoal

  void addImageFile(String idSoal, XFile file) {
    if (!imageFileMap.containsKey(idSoal)) {
      imageFileMap[idSoal] = [];
    }
    imageFileMap[idSoal]!.add(file);
    imageFileMap.refresh();
  }

  void clearImageFile(String idSoal) {
    imageFileMap[idSoal] = [];
    imageFileMap.refresh();
  }

  Future<void> onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
    bool isMultiImage = false,
    String? idSoal, // tambahkan ini
  }) async {
    if (isMultiImage) {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final List<XFile>? pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );

          if (pickedFileList != null) {
            imageFileList.addAll(pickedFileList);
          }
        } catch (e) {
          pickImageError = e;
        }
      });
    } else {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          if (pickedFile != null && idSoal != null) {
            addImageFile(idSoal, pickedFile);
          }
        } catch (e) {
          pickImageError = e;
        }
      });
    }
  }

  Future<void> _displayPickImageDialog(BuildContext context, onPick) async {
    return onPick(200.0, 200.0, 50);
  }

  void submit({bool isLast = false}) async {
    // Kumpulkan jawaban ke dalam List<SubmitKuisioner>
    List<SubmitKuisioner> dataToSend = [];

    for (var item in listKuisioner) {
      final idSoalStr = item.idSoal.toString();
      List<PhotoAttachment> attachments = [];

      final files = imageFileMap[idSoalStr] ?? [];
      for (var file in files) {
        if (!(await File(file.path).exists())) {
          EasyLoading.showError('Salah satu foto tidak ditemukan');
          return;
        }
        final photoBytes = await File(file.path).readAsBytes();
        final photoBase64 = base64Encode(photoBytes);

        attachments.add(
          PhotoAttachment(
            img: photoBase64,
            filename: file.path.split('/').last,
          ),
        );
      }

      dataToSend.add(
        SubmitKuisioner(
          idSoal: idSoalStr,
          idKategori: item.idKategori.toString(),
          jawaban: answers[idSoalStr] ?? "",
          idTrans: idKuisioner.value,
          photos: attachments.isEmpty ? null : attachments,
        ),
      );
    }

    final req = SubmitKuisionerRequest(data: dataToSend);
    final res = await apiRepository.submitKuisioner(req);
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      EasyLoading.dismiss();
      // Update currentProgress sesuai jumlah data yang disubmit
      currentProgress.value += dataToSend.length;
      // Jika progress sudah sama atau lebih dari total, tampilkan notif selesai
      bool isFinished = currentProgress.value >= allProgress.value;
      if (isLast || isFinished) {
        // Tampilkan dialog selesai
        Get.defaultDialog(
          title: 'Kuisioner Selesai',
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                CommonWidget.subtitleText(text: 'Semua kuisioner telah diisi!'),
                SizedBox(height: 30),
                LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 16,
                  color: Colors.green,
                  backgroundColor: Colors.green[100],
                ),
                SizedBox(height: 20),
                CustomButton(
                  buttonColor: ColorConstants.mainColor,
                  buttonText: 'KEMBALI KE HOME',
                  width: SizeConfig().screenWidth,
                  onPressed: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Future.delayed(Duration(milliseconds: 100), () {
          Get.offAllNamed(Routes.KUISIONER, arguments: {
            'id_kuisioner': idKuisioner.value,
            'id_group': idGroupKuisioner.value,
            'total_question': allProgress.value,
            'current_progress': currentProgress.value,
            'page': page.value + 1,
            'limit': 2
          });
        });
      }
    } else {
      EasyLoading.showError('Gagal disimpan');
      EasyLoading.dismiss();
    }
  }

  void updatePercentage() {
    if (allProgress.value > 0) {
      percentage.value = currentProgress.value / allProgress.value;
    } else {
      percentage.value = 0.0;
    }
  }

  @override
  void onInit() {
    super.onInit();
    ever(currentProgress, (_) => updatePercentage());
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();

    allProgress.value = argm['total_question'];
    percentage.value = 0.0;
    idKuisioner.value = argm['id_kuisioner'];
    idGroupKuisioner.value = argm['id_group'];
    currentProgress.value = argm['current_progress'] ?? 0;
    page.value = argm['page'] ?? 1;

    getKuisioner(page.value);
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
    endDate = selectedDate;
    endDateController.text =
        DateFormat("yyyy-MM-dd", "id_ID").format(selectedDate).toString();
  }

  void getKuisioner(page) async {
    final res = await apiRepository.listKuisioner(
        data: ListKuisionerRequest(
            id: idGroupKuisioner.value, limit: 2, page: page));
    listKuisioner.addAll(res?.data ?? []);
  }

  void onLoading() async {
    page.value = page.value + 1;

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    getKuisioner(page.value);
    refreshController.loadComplete();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listKuisioner.clear();
    page.value = 1;
    getKuisioner(page.value);
    refreshController.refreshCompleted();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class JawabanKuisioner {
  final String idSoal;
  final String idKategori;
  String jawaban;
  JawabanKuisioner(
      {required this.idSoal, required this.idKategori, this.jawaban = ""});
}
