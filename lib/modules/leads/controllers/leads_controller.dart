import 'dart:convert';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/attendance/attendance_wrapper.dart';
import 'package:staffku/models/request/leads/submit_lead.dart';
import 'package:staffku/models/response/izin/type_izin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:staffku/models/response/master_data_2_response.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:staffku/shared/constants/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadsController extends BaseController {
  LeadsController({required ApiRepository apiRepository})
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
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final noteController = TextEditingController();
  final TextEditingController agendaController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController minatProductController = TextEditingController();
  final ageController = TextEditingController();

  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString placement = "".obs;
  RxString nameItem = "".obs;
  RxString idType = "".obs;
  RxString idUser = "".obs;
  RxString token = "".obs;

  String date = "";
  DateTime dateNow = DateTime.now();

  RxString validationDate = "".obs;
  var listType = <DataTypeIzin>[].obs;

  var listLeadSource = <MasterData2>[].obs;
  var listLeadCategory = <MasterData2>[].obs;
  var listStatusLead = <MasterData2>[].obs;

  var masterData = <MasterData2>[].obs;
  var listGender = <MasterData2>[].obs;
  var listStatusPekerjaan = <MasterData2>[].obs;
  RxString genderValue = "".obs;
  RxString statusPekerjaan = "".obs;
  RxString idGender = ''.obs;

  RxString leadCategory = "".obs;
  RxString statusLead = "".obs;
  RxString leadSource = "".obs;
  RxString minatProduct = "".obs;
  RxInt leadCategoryId = 0.obs;
  RxInt statusLeadId = 0.obs;
  RxInt leadSourceId = 0.obs;
  RxInt statusPekerjaanId = 0.obs;
  RxString minatProductId = "".obs;

  RxString actionStatus = "".obs;
  RxString reason = "".obs;
  RxBool optionalText = false.obs;
  RxString optionalTextValue = ''.obs;

  void changeStatus(value, {String type = ''}) {
    if (value == 'Dll') {
      optionalText.value = true;
    }

    if (type == 'gender') {
      if (value.toLowerCase() == 'laki-laki') {
        idGender.value = 'L';
      } else {
        idGender.value = 'P';
      }
    }
  }

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

  void submit() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        noHpController.text.isEmpty ||
        alamatController.text.isEmpty ||
        minatProductController.text.isEmpty) {
      showInputError.value = true;
      EasyLoading.showError('Semua field wajib diisi');
      return;
    }

    if (imageFileList.isEmpty) {
      EasyLoading.showError('Foto belum tersedia');
      return;
    }

    List<PhotoAttachment> attachments = [];

    for (var file in imageFileList) {
      if (!(await File(file.path).exists())) {
        EasyLoading.showError('Salah satu foto tidak ditemukan');
        return;
      }

      final photoBytes = await File(file.path).readAsBytes();
      final photoBase64 = base64Encode(photoBytes);

      attachments.add(
        PhotoAttachment(img: photoBase64, filename: file.path.split('/').last),
      );
    }

    final res = await apiRepository.submitLead(
      SubmitLeadRequest(
        idUser: idUser.value,
        date: DateFormat("yyyy-MM-dd", "id_ID").format(dateNow).toString(),
        latitude: myLocation.latitude.toString(),
        longitude: myLocation.longitude.toString(),
        email: emailController.text,
        name: nameController.text,
        noHp: noHpController.text,
        leadSource: leadSourceId.value,
        optionLeadSource: optionalTextValue.value,
        leadCategory: leadCategoryId.value,
        minatProduct: minatProductController.text,
        leadStatus: statusLeadId.value,
        note: noteController.text,
        photos: attachments,
        alamat: alamatController.text,
        gender: idGender.value,
        age: ageController.text,
        statusPekerjaan: statusPekerjaanId.toString(),
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
        "Location permissions are permanently denied, we cannot request permissions.",
      );
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    myLocation = LatLng(position.latitude, position.longitude);

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
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

    listGender.add(MasterData2(id: 1, nama: 'Laki-Laki', flag: 'gender'));
    listGender.add(MasterData2(id: 2, nama: 'Perempuan', flag: 'gender'));
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
      listLeadSource.add(element);
    }

    masterData.clear();
    final resListLeadCategory = await apiRepository.getMasterData2(
      'Kategori Lead',
    );
    final leadCategoryData = resListLeadCategory?.data;
    if (leadCategoryData == null || leadCategoryData.isEmpty) {
      EasyLoading.showError('Gagal memuat master data');
      return;
    }
    masterData.value = leadCategoryData;
    for (var element in masterData) {
      listLeadCategory.add(element);
    }

    masterData.clear();
    final resListStatusLead = await apiRepository.getMasterData2('Status Lead');
    final statusLeadData = resListStatusLead?.data;
    if (statusLeadData == null || statusLeadData.isEmpty) {
      EasyLoading.showError('Gagal memuat master data');
      return;
    }
    masterData.value = statusLeadData;
    for (var element in masterData) {
      listStatusLead.add(element);
    }

    // listStatusPekerjaan.add(
    //     MasterData2(id: 1, nama: 'Karyawan Swasta', flag: 'status_pekerjaan'));
    // listStatusPekerjaan.add(MasterData2(
    //     id: 2, nama: 'Pegawai Negeri Sipil (PNS)', flag: 'status_pekerjaan'));
    // listStatusPekerjaan
    //     .add(MasterData2(id: 3, nama: 'TNI / Polri', flag: 'status_pekerjaan'));
    // listStatusPekerjaan
    //     .add(MasterData2(id: 4, nama: 'Wirausaha', flag: 'status_pekerjaan'));
    // listStatusPekerjaan
    //     .add(MasterData2(id: 5, nama: 'Freelancer', flag: 'status_pekerjaan'));
    // listStatusPekerjaan
    //     .add(MasterData2(id: 6, nama: 'Mahasiswa', flag: 'status_pekerjaan'));
    // listStatusPekerjaan
    //     .add(MasterData2(id: 7, nama: 'Pelajar', flag: 'status_pekerjaan'));
    // listStatusPekerjaan.add(
    //     MasterData2(id: 8, nama: 'Ibu Rumah Tangga', flag: 'status_pekerjaan'));
    // listStatusPekerjaan.add(
    //     MasterData2(id: 9, nama: 'Tidak Bekerja', flag: 'status_pekerjaan'));
    // listStatusPekerjaan
    //     .add(MasterData2(id: 10, nama: 'Pensiunan', flag: 'status_pekerjaan'));
    // listStatusPekerjaan
    masterData.clear();
    final resListStatusPekerjaan = await apiRepository.getMasterData2(
      'Status Kerja Leads',
    );
    final statusPekerjaanData = resListStatusPekerjaan?.data;
    if (statusPekerjaanData != null) {
      masterData.value = statusPekerjaanData;
      for (var element in masterData) {
        listStatusPekerjaan.add(element);
      }
    }
    // } else {
    //   listStatusPekerjaan.add(MasterData2(
    //       id: 1, nama: 'Karyawan Swasta', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan.add(MasterData2(
    //       id: 2, nama: 'Pegawai Negeri Sipil (PNS)', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan.add(
    //       MasterData2(id: 3, nama: 'TNI / Polri', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan
    //       .add(MasterData2(id: 4, nama: 'Wirausaha', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan.add(
    //       MasterData2(id: 5, nama: 'Freelancer', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan
    //       .add(MasterData2(id: 6, nama: 'Mahasiswa', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan
    //       .add(MasterData2(id: 7, nama: 'Pelajar', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan.add(MasterData2(
    //       id: 8, nama: 'Ibu Rumah Tangga', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan.add(
    //       MasterData2(id: 9, nama: 'Tidak Bekerja', flag: 'status_pekerjaan'));
    //   listStatusPekerjaan.add(
    //       MasterData2(id: 10, nama: 'Pensiunan', flag: 'status_pekerjaan'));
    // }
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

  @override
  void onClose() {
    super.onClose();
  }
}
