import 'package:staffku/api/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:staffku/models/request/lembur/submit_izin_request.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OvertimeController extends BaseController {
  OvertimeController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);
  var imageFileList = <XFile>[].obs;

  set _imageFile(XFile? value) {
    if (value == null) return;
    imageFileList.add(value);
  }

  dynamic pickImageError;
  RxString? retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final dateController = TextEditingController();
  final noteController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();

  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString placement = "".obs;
  RxString nameItem = "".obs;
  RxString idType = "".obs;
  RxString idUser = "".obs;
  RxString token = "".obs;

  String date = "";
  DateTime selectedDate = DateTime.now();
  RxString dateCnC = "".obs;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  RxString validationDate = "".obs;

  Future<void> onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
    bool isMultiImage = false,
  }) async {
    if (isMultiImage) {
      await _displayPickImageDialog(context!, (
        double? maxWidth,
        double? maxHeight,
        int? quality,
      ) async {
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
      await _displayPickImageDialog(context!, (
        double? maxWidth,
        double? maxHeight,
        int? quality,
      ) async {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );

          _imageFile = pickedFile;
        } catch (e) {
          pickImageError = e;
        }
      });
    }
  }

  void submit() {
    // Ambil jam dan menit dari controller
    final start = startTimeController.text.split(':');
    final end = endTimeController.text.split(':');

    if (start.length == 2 && end.length == 2) {
      final startHour = int.tryParse(start[0]) ?? 0;
      final startMinute = int.tryParse(start[1]) ?? 0;
      final endHour = int.tryParse(end[0]) ?? 0;
      final endMinute = int.tryParse(end[1]) ?? 0;

      final startTime = Duration(hours: startHour, minutes: startMinute);
      final endTime = Duration(hours: endHour, minutes: endMinute);

      if (endTime >= startTime) {
        submitData();
      } else {
        validationDate.value =
            'Jam selesai tidak boleh lebih awal dari jam mulai';
      }
    } else {
      validationDate.value = 'Format jam tidak valid';
    }
  }

  void submitData() async {
    if (startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty ||
        dateController.text.isEmpty ||
        noteController.text.isEmpty) {
      showInputError.value = true;
      EasyLoading.showError('Semua field wajib diisi');
      return;
    }

    final res = await apiRepository.submitLembur(
      SubmitLemburRequest(
        idUser: idUser.value,
        startTime: startTimeController.text,
        endTime: endTimeController.text,
        note: noteController.text,
        date: dateController.text,
      ),
    );
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      EasyLoading.dismiss();
      Get.back(result: true);
    } else {
      EasyLoading.showError('Gagal disimpan');
      EasyLoading.dismiss();
    }
  }

  Future<void> _displayPickImageDialog(BuildContext context, onPick) async {
    return onPick(200.0, 200.0, 50);
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
    dateController.text = DateFormat(
      "yyyy-MM-dd",
      "id_ID",
    ).format(selectedDate).toString();
  }

  Future<void> selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
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

  @override
  void onClose() {
    super.onClose();
  }
}
