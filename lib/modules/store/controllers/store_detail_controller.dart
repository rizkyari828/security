import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/attendance/attendance_wrapper.dart';
import 'package:sales/models/request/store/detail_request_leave.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sales/models/response/store/detail_store_response.dart';
import 'package:sales/modules/home/base_controller.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/constants/storage.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/utils/size_config.dart';
import 'package:sales/shared/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class StoreDetailController extends BaseController {
  StoreDetailController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  final argm = Get.arguments;
  var detail = DetailStore().obs;
  String date = "";
  DateTime selectedDate = DateTime.now();
  final noRequestController = TextEditingController();
  final noteController = TextEditingController();
  final noteApprovalController = TextEditingController();
  final qtyController = TextEditingController();
  final dateController = TextEditingController();
  final dateCnCController = TextEditingController();
  RxString dateCnC = "".obs;
  RxString dateGoods = "".obs;
  RxString nameItem = "".obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString name = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;
  RxString storeName = "".obs;
  RxString idStore = "".obs;
  RxString typeStore = "".obs;
  RxString statusKunjungan = "".obs;

  late LatLng myLocation = LatLng(0, 0);
  late LatLng dataLocation = LatLng(0, 0);
  var markers = <Marker>[].obs;
  var circles = Set<Circle>().obs;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  RxString locationDetail = "".obs;
  RxString locationStore = "".obs;

  RxBool isAbsent = false.obs;
  RxBool isAbsentOut = false.obs;
  RxBool canAbsent = false.obs;
  RxString absentTime = '00:00'.obs;
  RxString absentTimeOut = '00:00'.obs;
  RxBool isShowMaps = true.obs;

  RxString? retrieveDataError;

  RxString dateNow = DateFormat("dd MMMM yyyy HH:mm:ss", "id_ID")
      .format(DateTime.now())
      .toString()
      .obs;

  final ImagePicker _picker = ImagePicker();

  var imageFileList = <XFile>[].obs;
  dynamic pickImageError;

  set _imageFile(XFile? value) {
    if (value == null) return;
    imageFileList.add(value);
  }

  void showMaps() {
    isShowMaps.value = true;
  }

  void hideMaps() {
    isShowMaps.value = false;
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    name.value = prefs.getString('name') ?? "";
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
    userId.value = prefs.getString('userId') ?? "";
    token.value = prefs.getString('token') ?? "";
  }

  @override
  void onInit() {
    super.onInit();
    determinePosition();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();
    storeName.value = argm['storeName'];
    idStore.value = argm['id'];
    typeStore.value = argm['type'];
    statusKunjungan.value = argm['status_kunjungan'];
    getDetail();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getDetail() async {
    final res = await apiRepository.showDetailKunjungan(
        ShowDetailKunjunganRequest(
            id: idStore.value, type: typeStore.value, idUser: userId.value));
    // print(res!.data!);
    final data = res?.data;
    if (data != null && data.isNotEmpty) {
      detail.value = data.first;

      final lat = double.tryParse(detail.value.latToko ?? '');
      final lng = double.tryParse(detail.value.langToko ?? '');

      if (lat != null && lng != null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
          final place = placemarks.isNotEmpty ? placemarks.first : null;
          locationStore.value = place == null
              ? ''
              : "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
        } catch (e) {
          EasyLoading.showError('Location Toko tidak valid');
        }
      } else {
        EasyLoading.showError('Location Toko tidak valid');
      }
    } else {
      EasyLoading.showError('Gagal memuat detail toko');
    }
  }

  void attendanceSheetBar(String type) {
    imageFileList.clear();
    final sw = SizeConfig().screenWidth;
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    Get.bottomSheet(
        Container(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      CommonWidget.rowHeight(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: CommonWidget.minHeadText(
                              text: 'Unggah Foto Anda'),
                        ),
                      ),
                      CommonWidget.rowHeight(),
                      Obx(() => Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            height: sw * .4,
                            width: sw * .4,
                            child: imageFileList.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        20), // Image border
                                    child: Image.file(
                                        File(imageFileList.first.path)),
                                  )
                                : Center(
                                    child: CommonWidget.bodyText(
                                        text: "Anda belum memilih foto",
                                        color: Colors.grey),
                                  ),
                          )),
                      CommonWidget.rowHeight(),
                      InkWell(
                        onTap: () {
                          onImageButtonPressed(ImageSource.gallery,
                              context: Get.context);
                        },
                        child: DottedBorder(
                          options: RectDottedBorderOptions(
                            color: Colors.grey,
                            dashPattern: [8, 4],
                            strokeWidth: 1,
                          ),
                          child: Container(
                            height: 50,
                            width: sw,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                SizedBox(width: 10.0),
                                CommonWidget.bodyText(
                                    text: "Ambil Photo", color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                      CommonWidget.rowHeight(),
                      CustomButton(
                        buttonColor: ColorConstants.mainColor,
                        buttonText: 'SIMPAN',
                        width: sw,
                        onPressed: () {
                          // type == 'Clock In' ? submitIn() : submitOut();
                          submit(type);
                          // submitPhoto();
                          // controller.approval(action: 'approve');
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
        elevation: 20.0,
        enableDrag: false,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        )));
    // });
  }

  Widget previewImages() {
    if (imageFileList.isNotEmpty) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: kIsWeb
            ? Image.network(imageFileList.first.path)
            : Image.file(File(imageFileList.first.path)),
      );
    } else if (pickImageError != null) {
      return CommonWidget.bodyText(text: "Loading", color: Colors.grey);
    } else {
      return CommonWidget.bodyText(
          text: "Anda belum memilih foto", color: Colors.grey);
    }
  }

  void submit(String type) async {
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
        PhotoAttachment(
          img: photoBase64,
          filename: file.path.split('/').last,
        ),
      );
    }

    final wrapper = AttendanceSubmitRequestWrapper(
      idToko: argm['id'].toString(),
      latitude: myLocation.latitude.toString(),
      longitude: myLocation.longitude.toString(),
      idUser: userId.value,
      token: token.value,
      photos: attachments,
    );

    if (isConnectedToInternet.value == true) {
      final success = await _submitAttendance(wrapper);
      if (success) {
        EasyLoading.showSuccess('Berhasil ${type}');
        _afterSuccess();
      } else {
        EasyLoading.showError('Gagal ${type}');
        // _clearTempFile();
      }
    } else {
      _savePendingAttendance(wrapper);
      EasyLoading.showInfo('Tidak ada koneksi. Data disimpan sementara.');
      // _clearTempFile();
    }
  }

  void _afterSuccess() {
    isAbsent.value = true;
    absentTime.value = dateNow.value;
    isShowMaps.value = false;
    _clearTempFile();
    Get.back();
  }

  void _clearTempFile() {
    imageFileList.clear();
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

  Future<void> saveAttendanceOffline({
    required String idToko,
    required String latitude,
    required String longitude,
    required String idUser,
    required String token,
    required List<XFile> imageFiles,
  }) async {
    final storage = GetStorage();
    final stored = storage.read<List>('pendingAttendance') ?? [];

    final List<PhotoAttachment> photoList = [];

    for (final file in imageFiles) {
      final bytes = await file.readAsBytes();
      photoList.add(PhotoAttachment(
        img: base64Encode(bytes),
        filename: file.name,
      ));
    }

    final wrapper = AttendanceSubmitRequestWrapper(
      idToko: idToko,
      latitude: latitude,
      longitude: longitude,
      idUser: idUser,
      token: token,
      photos: photoList,
    );

    // Append ke list yang sudah ada
    stored.add(wrapper.toJson());

    await storage.write('pendingAttendance', stored);
  }

  Future<bool> _submitAttendance(AttendanceSubmitRequestWrapper wrapper) async {
    try {
      final request = wrapper;

      final res = await apiRepository.submitAttendanceStore(request);
      return res?.message == "sukses";
    } catch (e) {
      print("Error saat submit: $e");
      return false;
    }
  }

  Future<void> onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    // imageFileList.clear();
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

  Future<void> _displayPickImageDialog(BuildContext context, onPick) async {
    return onPick(200.0, 200.0, 50);
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
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      final place = placemarks.isNotEmpty ? placemarks.first : null;
      locationDetail.value = place == null
          ? ''
          : "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
    } catch (e) {
      EasyLoading.showError('Location Toko tidak valid');
    }

    final prefs = Get.find<SharedPreferences>();
    if (prefs.getString('token') != null) {
      prefs.setDouble(StorageConstants.initLatitude, position.latitude);
      prefs.setDouble(StorageConstants.initLongitude, position.longitude);
    }

    EasyLoading.dismiss();
  }

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2028),
    );
    if (selected != null && selected != selectedDate) selectedDate = selected;
    dateCnC.value = selectedDate.toString();
  }
}
