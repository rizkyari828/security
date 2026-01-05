import 'dart:convert';
import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/attendance/attendance_wrapper.dart';
import 'package:staffku/models/request/kunjungan/non_schedule_request.dart';
import 'package:staffku/models/response/master_data_2_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:staffku/shared/constants/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreAddController extends BaseController {
  StoreAddController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  String date = "";
  DateTime selectedDate = DateTime.now();
  final noteController = TextEditingController();
  final nameController = TextEditingController();
  final visitNoteController = TextEditingController();
  final planExecutionController = TextEditingController();
  final agendaController = TextEditingController();
  final alamatController = TextEditingController();
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;
  RxInt idUser = 0.obs;
  RxInt idSource = 0.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  final nickname = TextEditingController();

  var listAgenda = <MasterData2>[].obs;
  var listStatus = <MasterData2>[].obs;
  RxBool optionalText = false.obs;
  RxString agenda = "".obs;
  RxString status = "".obs;
  RxString agendaId = "".obs;
  RxString statusId = "".obs;

  late LatLng myLocation = LatLng(0, 0);

  RxString locationDetail = "".obs;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  var masterData = <MasterData2>[].obs;
  var listSourceOfOrder = <MasterData2>[].obs;

  final ImagePicker _picker = ImagePicker();

  var imageFileList = <XFile>[].obs;
  dynamic pickImageError;

  RxString? retrieveDataError;

  set _imageFile(XFile? value) {
    if (value == null) return;
    imageFileList.add(value);
  }

  void changeStatus(String value) {
    if (value == 'Dll') {
      optionalText.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    determinePosition();
    _checkInitialConnection().then((_) {
      getMasterData();
    });
    ever(isConnectedToInternet, (bool connected) {
      getMasterData();
    });
  }

  Future<void> _checkInitialConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnectedToInternet.value = true;
      } else {
        isConnectedToInternet.value = false;
      }
    } on SocketException catch (_) {
      isConnectedToInternet.value = false;
    }
  }

  void getMasterData() async {
    final storage = GetStorage();
    masterData.clear();

    if (isConnectedToInternet.value == true) {
      // Ambil dari API dan simpan ke storage
      final resListAgenda = await apiRepository.getMasterData2(
        'aktifitas_kunjungan',
        userId: userId.value,
      );
      if (resListAgenda?.data != null) {
        masterData.value = resListAgenda!.data!;
        listAgenda.assignAll(masterData);
        // Simpan ke storage
        storage.write('listAgenda', masterData.map((e) => e.toJson()).toList());
      }

      masterData.clear();
      final resListStatus = await apiRepository.getMasterData2(
        'status_kunjungan',
        userId: userId.value,
      );
      if (resListStatus?.data != null) {
        masterData.value = resListStatus!.data!;
        listStatus.assignAll(masterData);
        // Simpan ke storage
        storage.write('listStatus', masterData.map((e) => e.toJson()).toList());
      }
    } else {
      // Ambil dari storage jika offline
      final agendaJson = storage.read<List>('listAgenda');
      if (agendaJson != null) {
        listAgenda.assignAll(
          agendaJson
              .map((e) => MasterData2.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }

      final statusJson = storage.read<List>('listStatus');
      if (statusJson != null) {
        listStatus.assignAll(
          statusJson
              .map((e) => MasterData2.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();
    // ever(isConnectedToInternet, (bool connected) {
    //   getMasterData();
    // });
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

  Future<void> onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
    bool isMultiImage = false,
  }) async {
    // imageFileList.clear();
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

  Future<void> _displayPickImageDialog(BuildContext context, onPick) async {
    return onPick(200.0, 200.0, 50);
  }

  void submit() async {
    if (nameController.text.isEmpty ||
        alamatController.text.isEmpty ||
        agendaId.value.isEmpty ||
        statusId.value.isEmpty ||
        visitNoteController.text.isEmpty ||
        planExecutionController.text.isEmpty) {
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

    // if (agenda.value == 'Dll') {
    //   agenda.value == agendaController.text;
    // }

    final wrapper = AttendanceSubmitRequestWrapper(
      latitude: myLocation.latitude.toString(),
      longitude: myLocation.longitude.toString(),
      idUser: userId.value,
      token: token.value,
      photos: attachments,
      //NON
      name: nameController.text,
      type: 'non schedule',
      alamat: alamatController.text,
      agenda: agendaId.value,
      status: statusId.value,
      visitNote: visitNoteController.text,
      planExecution: planExecutionController.text,
    );

    if (isConnectedToInternet.value == true) {
      final success = await _submitAttendance(wrapper);
      if (success) {
        EasyLoading.showSuccess('Berhasil');
        _afterSuccess();
      } else {
        EasyLoading.showError('Gagal');
        // _clearTempFile();
      }
    } else {
      _savePendingAttendance(wrapper);
      EasyLoading.showInfo('Tidak ada koneksi. Data disimpan sementara.');
      Get.back(result: true);
      // _clearTempFile();
    }
  }

  void _afterSuccess() {
    _clearTempFile();
    Get.back(result: true);
  }

  void _clearTempFile() {
    imageFileList.clear();
  }

  Future<bool> _submitAttendance(AttendanceSubmitRequestWrapper wrapper) async {
    try {
      final nonScheduleRequest = NonScheduleSubmitRequest(
        latitude: wrapper.latitude,
        longitude: wrapper.longitude,
        idUser: wrapper.idUser,
        photos: wrapper.photos,
        // NON
        name: wrapper.name,
        alamat: wrapper.alamat,
        agenda: wrapper.agenda,
        status: wrapper.status,
        visitNote: wrapper.visitNote,
        planExecution: wrapper.planExecution,
      );

      final res = await apiRepository.submitNonScheduleVisited(
        nonScheduleRequest,
      );
      return res?.message == "sukses";
    } catch (e) {
      print("Error saat submit: $e");
      return false;
    }
  }

  void _savePendingAttendance(AttendanceSubmitRequestWrapper wrapper) {
    final storage = GetStorage();
    final existing = storage.read<List>('pendingAttendance');
    String today = DateTime.now().toIso8601String().substring(0, 10);
    final data = wrapper.toJson(date: today);

    // Cek duplikasi berdasarkan id_toko dan tanggal (YYYY-MM-DD)
    bool isDuplicate = false;
    if (existing != null) {
      for (final item in existing) {
        final map = Map<String, dynamic>.from(item);
        final idToko = map['id_toko']?.toString() ?? '';
        final date = map['date']?.toString() ?? '';
        if (idToko == wrapper.idToko) {
          String itemDate = date.isNotEmpty ? date.substring(0, 10) : today;
          if (itemDate == today) {
            isDuplicate = true;
            break;
          }
        }
      }
    }
    if (!isDuplicate) {
      if (existing != null) {
        final updatedList = List<Map<String, dynamic>>.from(existing)
          ..add(data);
        storage.write('pendingAttendance', updatedList);
      } else {
        storage.write('pendingAttendance', [data]);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
