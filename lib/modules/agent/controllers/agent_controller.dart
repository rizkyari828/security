import 'dart:convert';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/agent/submit_agent.dart';
import 'package:sales/models/request/attendance/attendance_wrapper.dart';
import 'package:sales/models/response/izin/type_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sales/models/response/master_data_2_response.dart';
import 'package:sales/modules/home/base_controller.dart';
import 'package:sales/shared/constants/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

class AgentController extends BaseController {
  AgentController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);
  var imageFileList = <XFile>[].obs;

  set _imageFile(XFile? value) {
    if (value == null) return;
    imageFileList.add(value);
  }

  dynamic pickImageError;
  RxString? retrieveDataError;
  RxString locationDetail = "".obs;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  late LatLng myLocation = LatLng(0, 0);

  final ImagePicker _picker = ImagePicker();
  final noteController = TextEditingController();
  final TextEditingController placementController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController agentNameController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController dateCalled = TextEditingController();
  final TextEditingController registerByController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String date = "";
  DateTime dateNow = DateTime.now();

  RxString validationDate = "".obs;
  var listType = <DataTypeIzin>[].obs;

  var masterData = <MasterData2>[].obs;
  var listTypeAgent = <MasterData2>[].obs;
  var listStatusActive = <MasterData2>[].obs;
  RxString statusActive = "".obs;
  RxString typeAgent = "".obs;
  RxString typeAgentId = "".obs;
  RxString statusActiveId = "".obs;
  RxString leadSourceId = "".obs;

  RxString actionStatus = "".obs;
  RxString reason = "".obs;
  RxBool optionalText = false.obs;
  RxString optionalTextValue = ''.obs;

  void changeStatus(value) {
    if (value == 'Dll') {
      optionalText.value = true;
    }
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

  Future<void> onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
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

          _imageFile = pickedFile;
        } catch (e) {
          pickImageError = e;
        }
      });
    }
  }

  void submit() async {
    // Validasi signature
    final signatureBytes = await signatureController.toPngBytes();
    if (signatureBytes == null || signatureBytes.isEmpty) {
      EasyLoading.showError('Tanda tangan belum diisi');
      return;
    }
    final signatureBase64 = base64Encode(signatureBytes);

    // Validasi foto
    if (imageFileList.isEmpty) {
      EasyLoading.showError('Foto belum tersedia');
      return;
    }

    // Siapkan lampiran foto
    List<PhotoAttachment> photoAttachments = [];
    for (var file in imageFileList) {
      if (!(await File(file.path).exists())) {
        EasyLoading.showError('Salah satu foto tidak ditemukan');
        return;
      }
      final photoBytes = await File(file.path).readAsBytes();
      final photoBase64 = base64Encode(photoBytes);
      photoAttachments.add(
        PhotoAttachment(
          img: photoBase64,
          filename: file.path.split('/').last,
        ),
      );
    }

    // Siapkan lampiran signature
    List<PhotoAttachment> signatureAttachments = [
      PhotoAttachment(
        img: signatureBase64,
        filename: "signature.png",
      ),
    ];

    // Submit request
    final res = await apiRepository.submitAgent(
      SubmitAgentRequest(
        idUser: userId.value,
        fullName: fullNameController.text,
        agentName: agentNameController.text,
        email: emailController.text,
        alamat: alamatController.text,
        placement: placementController.text,
        joinDate: joinDateController.text,
        typeAgentId: typeAgentId.value,
        registerBy: registerByController.text,
        statusActiveId: statusActiveId.value,
        signature: signatureAttachments,
        photos: photoAttachments,
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

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        "Error",
        "Location services are disabled.",
        icon: Icon(Icons.person, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        isDismissible: true,
        //dismissDirection: SnackDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.easeOutBack,
      );

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Error",
          "Location permissions are denied",
          icon: Icon(Icons.person, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          isDismissible: true,
          //dismissDirection: SnackDismissDirection.HORIZONTAL,
          forwardAnimationCurve: Curves.easeOutBack,
        );
        print("Location permissions are denied");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Error",
        "Location permissions are permanently denied, we cannot request permissions.",
        icon: Icon(Icons.person, color: Colors.white),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        borderRadius: 20,
        margin: EdgeInsets.all(15),
        colorText: Colors.white,
        duration: Duration(seconds: 4),
        isDismissible: true,
        //dismissDirection: SnackDismissDirection.HORIZONTAL,
        forwardAnimationCurve: Curves.easeOutBack,
      );
      print(
          "Location permissions are permanently denied, we cannot request permissions.");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    myLocation = LatLng(position.latitude, position.longitude);

    try {
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      final place = placemarks.isNotEmpty ? placemarks.first : null;
      locationDetail.value = place == null
          ? ''
          : "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
    } catch (_) {
      locationDetail.value = '';
    }

    final prefs = Get.find<SharedPreferences>();
    if (prefs.getString('token') != null) {
      prefs.setDouble(StorageConstants.initLatitude, position.latitude);
      prefs.setDouble(StorageConstants.initLongitude, position.longitude);
    }

    EasyLoading.dismiss();
  }

  Future<void> _displayPickImageDialog(BuildContext context, onPick) async {
    return onPick(200.0, 200.0, 50);
  }

  @override
  void onInit() {
    super.onInit();

    determinePosition();
    getMasterData();
  }

  void getMasterData() async {
    masterData.clear();
    final resListLeadSource = await apiRepository.getMasterData2('Sumber Lead');
    final leadSourceData = resListLeadSource?.data;
    if (leadSourceData == null || leadSourceData.isEmpty) {
      EasyLoading.showError('Gagal memuat master data');
      return;
    }
    masterData.value = leadSourceData;

    for (var element in masterData) {
      listTypeAgent.add(element);
    }

    masterData.clear();
    final resListLeadCategory =
        await apiRepository.getMasterData2('Kategori Lead');
    final leadCategoryData = resListLeadCategory?.data;
    if (leadCategoryData == null || leadCategoryData.isEmpty) {
      EasyLoading.showError('Gagal memuat master data');
      return;
    }
    masterData.value = leadCategoryData;
    for (var element in masterData) {
      listStatusActive.add(element);
    }

    masterData.clear();
    final resListStatusLead = await apiRepository.getMasterData2('Status Lead');
    final statusLeadData = resListStatusLead?.data;
    if (statusLeadData == null || statusLeadData.isEmpty) {
      EasyLoading.showError('Gagal memuat master data');
      return;
    }
    masterData.value = statusLeadData;
  }

  final signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
