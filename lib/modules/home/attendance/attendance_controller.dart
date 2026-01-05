import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:staffku/models/request/attendance/submit_attendance.dart';
import 'package:staffku/models/request/attendance/validate_attenance.dart';
import 'package:staffku/models/response/attendance/attendance_validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:staffku/api/api.dart';
import 'package:staffku/models/response/user/users_response.dart';
import 'package:staffku/modules/home/home.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:staffku/shared/services/face_recognition/face_recognition_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:face_camera/face_camera.dart';

class AttendanceController extends FaceRecognitionController {
  AttendanceController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  var currentTab = MainTabs.home.obs;
  var users = Rxn<UsersResponse>();
  var user = Rxn<Datum>();
  var markers = <Marker>[].obs;
  var circles = Set<Circle>().obs;
  // List<Marker> markers = <Marker>[];

  late MainTab mainTab;
  late DiscoverTab discoverTab;
  late MeTab meTab;
  late LatLng myLocation = LatLng(0, 0);
  late ValidateData userSchedule;
  final RxString distanceToOffice = ''.obs;
  final Rxn<LatLng> officeLocation = Rxn<LatLng>();

  String? namaLokasi;
  RxBool isClockIn = false.obs;
  RxString timeString = '--:--'.obs;
  RxString timeIn = '--:--'.obs;
  RxString timeOut = '--:--'.obs;
  RxString duration = '--:--'.obs;
  RxBool isPhoto = false.obs;

  final String currentTime = getSystemTime();

  RxString name = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;

  var imageFileList = <XFile>[].obs;

  set _imageFile(XFile? value) {
    if (value == null) return;
    imageFileList.add(value);
  }

  dynamic pickImageError;
  RxString? retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  late BuildContext context;

  static String getSystemTime() {
    var now = new DateTime.now();
    return new DateFormat("H:m:s").format(now);
  }

  void submitPhoto() {
    isPhoto.value = true;
    Get.back();
  }

  void _refreshHomeAttendanceCard() {
    if (!Get.isRegistered<HomeController>()) return;
    Get.find<HomeController>().getAttendanceInfo();
  }

  void submit(String type) async {
    final file = faceCameraCapture?.value;
    if (file != null) {
      final res = await apiRepository.submitAttendance(
        AttendanceSubmitRequest(
          latitude: myLocation.latitude.toString(),
          longitude: myLocation.longitude.toString(),
          idUser: userId.value,
          token: token.value,
          // photo: MultipartFile(await imageFileList.first.readAsBytes(),
          //     filename: imageFileList.first.name),
          photo: MultipartFile(
            await file.readAsBytes(),
            filename: file.path.split('/').last,
          ),
        ),
      );
      if (res == null) {
        EasyLoading.showError('Gagal mengirim absensi');
        return;
      }

      if (res.message == "berhasil absen masuk") {
        if (type == 'Clock In') {
          EasyLoading.showSuccess('Berhasil Clock In');
          var now = new DateTime.now();
          timeIn.value = DateFormat("HH:mm:ss").format(now);
        } else {
          EasyLoading.showSuccess('Berhasil Clock Out');
          var now = new DateTime.now();
          timeOut.value = DateFormat("HH:mm:ss").format(now);
        }

        validateAttandance();
        _refreshHomeAttendanceCard();

        faceCameraCapture?.value = File('');
        Get.back();
      } else {
        faceCameraCapture?.value = File('');
        if (type == 'Clock In') {
          EasyLoading.showError('Gagal Clock In');
        } else {
          EasyLoading.showError('Gagal Clock Out');
        }
      }
    } else {
      EasyLoading.showError('Foto belum tersedia');
    }
  }

  void submitOut(String type) async {
    final file = faceCameraCapture?.value;
    if (file != null) {
      final res = await apiRepository.submitAttendanceOut(
        AttendanceSubmitRequest(
          latitude: myLocation.latitude.toString(),
          longitude: myLocation.longitude.toString(),
          idUser: userId.value,
          token: token.value,
          // photo: MultipartFile(await imageFileList.first.readAsBytes(),
          //     filename: imageFileList.first.name),
          photo: MultipartFile(
            await file.readAsBytes(),
            filename: file.path.split('/').last,
          ),
        ),
      );
      print(res);
      if (res == null) {
        EasyLoading.showError('Gagal mengirim absensi');
        return;
      }

      if (res.message == "berhasil absen keluar") {
        EasyLoading.showSuccess('Berhasil Clock Out');
        var now = new DateTime.now();
        timeOut.value = DateFormat("HH:mm:ss").format(now);

        validateAttandance();
        _refreshHomeAttendanceCard();

        Get.back();
      } else {
        EasyLoading.showError('Gagal Clock Out');
      }
    } else {
      EasyLoading.showError('Foto belum tersedia');
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
    // markers.add(Marker(
    //     markerId: MarkerId('SomeId'),
    //     position: LatLng(position.latitude, position.longitude),
    //     infoWindow: InfoWindow(title: 'The title of the marker')));

    final prefs = Get.find<SharedPreferences>();
    if (prefs.getString('token') != null) {
      prefs.setDouble(StorageConstants.initLatitude, position.latitude);
      prefs.setDouble(StorageConstants.initLongitude, position.longitude);
    }

    EasyLoading.dismiss();
  }

  @override
  void onInit() async {
    super.onInit();
    loadUsersLatLang();
    determinePosition();
    loadUsers();
    // attendanceSheetBar();
    mainTab = MainTab();
    discoverTab = DiscoverTab();
    meTab = MeTab();
    // getSchedule();
    validateAttandance();
    faceCameraController = FaceCameraController(
      autoCapture: false,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        faceCameraCapture?.value = image ?? File('');
      },
      onFaceDetected: (Face? face) {
        //Do something
      },
    );
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    name.value = prefs.getString('name') ?? "";
    userId.value = prefs.getString('userId') ?? "";
    token.value = prefs.getString('token') ?? "";
  }

  Future<void> onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
    bool isMultiImage = false,
  }) async {
    imageFileList.clear();
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
                      child: CommonWidget.minHeadText(text: 'Unggah Foto Anda'),
                    ),
                  ),
                  CommonWidget.rowHeight(),
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      height: sw * .4,
                      width: sw * .4,
                      child: imageFileList.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                20,
                              ), // Image border
                              child: Image.file(File(imageFileList.first.path)),
                            )
                          : Center(
                              child: CommonWidget.bodyText(
                                text: "Anda belum memilih foto",
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  CommonWidget.rowHeight(),
                  InkWell(
                    onTap: () {
                      onImageButtonPressed(
                        ImageSource.camera,
                        context: Get.context,
                      );
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
                              text: "Ambil Photo",
                              color: Colors.grey,
                            ),
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
                      submit(type);
                      // submitPhoto();
                      // controller.approval(action: 'approve');
                    },
                  ),
                ],
              ),
            ),
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
        ),
      ),
    );
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
        text: "Anda belum memilih foto",
        color: Colors.grey,
      );
    }
  }

  loadUsersLatLang() async {
    var prefs = Get.find<SharedPreferences>();
    myLocation = LatLng(
      prefs.getDouble('initLatitude') ?? 0.0,
      prefs.getDouble('initLongitude') ?? 0.0,
    );
  }

  Future<void> onRefresh() async {
    isClockIn.value = false;
    timeString.value = '--:--';
    timeIn.value = '--:--';
    timeOut.value = '--:--';
    duration.value = '--:--';
    distanceToOffice.value = '';
    officeLocation.value = null;
    markers.clear();
    determinePosition();
    validateAttandance();
  }

  void validateAttandance() async {
    try {
      final res = await apiRepository.validateAttendance(
        AttendanceValidateRequest(
          latitude: myLocation.latitude.toString(),
          longitude: myLocation.longitude.toString(),
          id: userId.value.toString(),
          token: token.value.toString(),
        ),
      );
      print(res);
      userSchedule = res?.data?.first ?? userSchedule;
      distanceToOffice.value = res?.data?.first.jarak?.toString() ?? '';

      LatLng _myOffice = LatLng(
        res?.data?.first.latitude ?? 0.0,
        res?.data?.first.longitude ?? 0.0,
      );
      officeLocation.value = _myOffice;

      circles.add(
        Circle(
          circleId: CircleId('A1'),
          center: _myOffice,
          radius: 150,
          fillColor: CommonWidget.setOpacity(
            ColorConstants.secondaryAppColor,
            0.9,
          ),
          strokeWidth: 3,
          strokeColor: CommonWidget.setOpacity(
            ColorConstants.secondaryAppColor,
            0.9,
          ),
        ),
      );

      if (res?.data?.first.flag == "1") {
        isClockIn.value = true;
        if (res?.data?.first.absenIn != '') {
          // DateTime parseDateIn =
          //     DateTime.parse(res?.data?.first.absenIn.toString() ?? '');
          timeIn.value = res?.data?.first.absenIn.toString() ?? '';
        }
        if (res?.data?.first.absenOut != '') {
          // DateTime parseDateOut =
          //     DateTime.parse(res?.data?.first.absenOut.toString() ?? '');
          // DateTime parseDateIn =
          //     DateTime.parse(res?.data?.first.absenIn.toString() ?? '');
          timeOut.value = res?.data?.first.absenOut.toString() ?? '';
        }
      } else {
        isClockIn.value = false;
      }

      _updateDuration();
    } catch (e) {
      distanceToOffice.value = '';
      officeLocation.value = null;
      isClockIn.value = false;
    }
  }

  void _updateDuration() {
    final inTime = _tryParseClockTime(timeIn.value);
    final outTime = _tryParseClockTime(timeOut.value);
    if (inTime == null || outTime == null) {
      duration.value = '--:--';
      return;
    }

    var diff = outTime.difference(inTime);
    if (diff.isNegative) {
      diff += const Duration(days: 1);
    }

    duration.value = _formatDuration(diff);
  }

  DateTime? _tryParseClockTime(String value) {
    final raw = value.trim();
    if (raw.isEmpty || raw == '--:--') return null;

    try {
      final t = DateFormat('HH:mm:ss', 'id_ID').parseLoose(raw);
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, t.hour, t.minute, t.second);
    } catch (_) {
      return null;
    }
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours <= 0) return '${minutes}m';
    return '${hours}j ${minutes}m';
  }

  void switchTab(index) {
    var tab = _getCurrentTab(index);
    currentTab.value = tab;
  }

  int getCurrentIndex(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return 0;
      case MainTabs.discover:
        return 1;
      case MainTabs.inbox:
        return 2;
      case MainTabs.me:
        return 3;
      default:
        return 0;
    }
  }

  MainTabs _getCurrentTab(int index) {
    switch (index) {
      case 0:
        return MainTabs.home;
      case 1:
        return MainTabs.discover;
      case 2:
        return MainTabs.inbox;
      case 3:
        return MainTabs.me;
      default:
        return MainTabs.home;
    }
  }

  void goToLoginPages() {
    Get.toNamed(Routes.LOGIN);
  }

  void goToIzinPages() {
    Get.toNamed(Routes.LEAVE);
  }

  void goToLemburPages() {
    Get.toNamed(Routes.PROSPEK);
  }

  void goToCutiPages() {
    Get.toNamed(Routes.BENEFIT);
  }

  void goToRecapPages() {
    Get.toNamed(Routes.RECAP);
  }

  @override
  void onClose() {}
}
