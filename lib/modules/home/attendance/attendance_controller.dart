import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
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
import 'package:staffku/shared/services/face_biometrics/face_biometrics_service.dart';

class AttendanceController extends FaceRecognitionController {
  AttendanceController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  static const String _tuningProfileRaw = String.fromEnvironment(
    'FACE_TUNING_PROFILE',
    defaultValue: 'balanced',
  );
  static const String _minimumFaceSimilarityRaw = String.fromEnvironment(
    'FACE_MIN_SIMILARITY',
    defaultValue: '',
  );
  static const String _verificationFrameCountRaw = String.fromEnvironment(
    'FACE_VERIFICATION_FRAMES',
    defaultValue: '',
  );
  static const String _minimumVerificationSamplesRaw = String.fromEnvironment(
    'FACE_MIN_VERIFICATION_SAMPLES',
    defaultValue: '',
  );
  static const String _minimumVerificationMatchesRaw = String.fromEnvironment(
    'FACE_MIN_VERIFICATION_MATCHES',
    defaultValue: '',
  );
  static const String _minimumSharpnessRaw = String.fromEnvironment(
    'FACE_MIN_SHARPNESS',
    defaultValue: '',
  );
  static const String _minimumBrightnessRaw = String.fromEnvironment(
    'FACE_MIN_BRIGHTNESS',
    defaultValue: '',
  );
  static const String _maximumBrightnessRaw = String.fromEnvironment(
    'FACE_MAX_BRIGHTNESS',
    defaultValue: '',
  );
  static const String _attendanceRadiusMetersRaw = String.fromEnvironment(
    'ATTENDANCE_RADIUS_METERS',
    defaultValue: '',
  );
  static const bool _faceDebugTelemetryFlag = bool.fromEnvironment(
    'FACE_DEBUG_TELEMETRY',
    defaultValue: false,
  );

  static final _FaceTuningConfig _faceTuning = _buildFaceTuningConfig();

  static const int _minimumFaceEmbeddingLength = 64;
  static const int _maxFaceTelemetryEntries = 60;

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final FaceBiometricsService _faceBiometrics =
      Get.find<FaceBiometricsService>();

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
  GoogleMapController? _mapController;
  final RxDouble mapZoom = 18.0.obs;
  late ValidateData userSchedule;
  final RxString distanceToOffice = ''.obs;
  final Rxn<LatLng> officeLocation = Rxn<LatLng>();
  final RxList<List<double>> serverFaceEmbeddings = <List<double>>[].obs;
  final RxBool isFaceIdReady = false.obs;
  final RxBool isWithinAttendanceArea = false.obs;
  final RxList<Map<String, dynamic>> faceTelemetryLogs =
      <Map<String, dynamic>>[].obs;

  String? namaLokasi;
  RxBool isClockIn = false.obs;
  RxString timeString = '--:--'.obs;
  RxString timeIn = '--:--'.obs;
  RxString timeOut = '--:--'.obs;
  RxString duration = '--:--'.obs;
  RxBool isPhoto = false.obs;
  final RxBool isPreparingClockAction = false.obs;
  final RxBool isRefreshingFaceData = false.obs;
  final RxBool isSubmittingAttendance = false.obs;

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

  void submit(String _) async {
    final file = faceCameraCapture?.value;
    if (file != null && file.path.isNotEmpty) {
      final verified = await _verifyFaceWithServerTemplates(
        file,
        action: 'clock_in',
      );
      if (!verified) return;
      await _submitAttendanceToApi(file: file, isClockOut: false);
    } else {
      EasyLoading.showError('Foto belum tersedia');
    }
  }

  void submitOut(String _) async {
    final file = faceCameraCapture?.value;
    if (file != null && file.path.isNotEmpty) {
      final verified = await _verifyFaceWithServerTemplates(
        file,
        action: 'clock_out',
      );
      if (!verified) return;
      await _submitAttendanceToApi(file: file, isClockOut: true);
    } else {
      EasyLoading.showError('Foto belum tersedia');
    }
  }

  Future<void> _submitAttendanceToApi({
    required File file,
    required bool isClockOut,
  }) async {
    if (isSubmittingAttendance.value) return;
    isSubmittingAttendance.value = true;
    final fileName = file.path.split(RegExp(r'[\\/]')).last;

    try {
      EasyLoading.show(
        status: isClockOut ? 'Mengirim Clock Out...' : 'Mengirim Clock In...',
      );

      final req = AttendanceSubmitRequest(
        latitude: myLocation.latitude.toString(),
        longitude: myLocation.longitude.toString(),
        idUser: userId.value,
        token: token.value,
        photo: MultipartFile(await file.readAsBytes(), filename: fileName),
      );

      final res = isClockOut
          ? await apiRepository.submitAttendanceOut(req)
          : await apiRepository.submitAttendance(req);

      EasyLoading.dismiss();

      if (res == null || res.error == true) {
        EasyLoading.showError(
          res?.message?.toString().trim().isNotEmpty == true
              ? res!.message.toString()
              : (isClockOut ? 'Gagal Clock Out' : 'Gagal Clock In'),
        );
        return;
      }

      final now = DateTime.now();
      if (isClockOut) {
        timeOut.value = DateFormat("HH:mm:ss").format(now);
        EasyLoading.showSuccess('Berhasil Clock Out');
      } else {
        timeIn.value = DateFormat("HH:mm:ss").format(now);
        EasyLoading.showSuccess('Berhasil Clock In');
      }

      await validateAttandance();
      _refreshHomeAttendanceCard();
      faceCameraCapture?.value = File('');
      Get.back();
    } catch (_) {
      EasyLoading.dismiss();
      EasyLoading.showError(isClockOut ? 'Gagal Clock Out' : 'Gagal Clock In');
    } finally {
      isSubmittingAttendance.value = false;
    }
  }

  void _refreshHomeAttendanceCard() {
    if (!Get.isRegistered<HomeController>()) return;
    unawaited(Get.find<HomeController>().getAttendanceInfo());
  }

  Future<bool> _verifyFaceWithServerTemplates(
    File file, {
    required String action,
  }) async {
    final currentUserId = userId.value.trim();
    final stopwatch = Stopwatch()..start();
    var outcome = 'unknown';
    var matched = false;
    var hasFaceData = false;
    var capturedFrames = 0;
    var validFrames = 0;
    var passedFrames = 0;
    var medianScore = 0.0;
    final qualityIssues = <String>[];
    final scorePerFrame = <double>[];

    if (currentUserId.isEmpty) {
      outcome = 'missing_user';
      EasyLoading.showError('User belum tersedia');
      return false;
    }

    try {
      EasyLoading.show(status: 'Verifikasi wajah multi-sampel...');
      await validateAttandance();

      hasFaceData = serverFaceEmbeddings.isNotEmpty;
      var validTemplates = _extractValidServerEmbeddings();
      isFaceIdReady.value = validTemplates.isNotEmpty;
      if (validTemplates.isEmpty) {
        outcome = hasFaceData ? 'invalid_server_template' : 'not_enrolled';
        EasyLoading.dismiss();
        EasyLoading.showError(
          hasFaceData
              ? 'Data Face ID tidak valid. Silakan daftar ulang Face ID.'
              : 'Face ID belum terdaftar. Silakan daftar dulu.',
        );
        return false;
      }

      final frames = await _captureVerificationFrames(primaryFrame: file);
      capturedFrames = frames.length;
      if (frames.length < _faceTuning.minimumVerificationSamples) {
        outcome = 'insufficient_frames';
        EasyLoading.dismiss();
        EasyLoading.showError(
          'Gagal mengambil sampel wajah tambahan. Coba ulangi.',
        );
        return false;
      }

      final tempFrames = frames.skip(1).toList(growable: false);
      try {
        for (final frame in frames) {
          final issue = await _faceQualityIssue(frame);
          if (issue != null) {
            qualityIssues.add(issue);
            continue;
          }

          final sampleEmbedding =
              await _faceBiometrics.embeddingFromFile(frame);
          if (!ValidateData.isValidEmbedding(
            sampleEmbedding,
            minLength: _minimumFaceEmbeddingLength,
          )) {
            qualityIssues.add(
              'Sampel wajah tidak valid. Pastikan wajah menghadap kamera.',
            );
            continue;
          }

          validTemplates = _extractValidServerEmbeddings(
            expectedLength: sampleEmbedding.length,
          );
          if (validTemplates.isEmpty) {
            outcome = 'template_dimension_mismatch';
            EasyLoading.dismiss();
            EasyLoading.showError(
              'Format Face ID tidak cocok. Silakan daftar ulang Face ID.',
            );
            return false;
          }

          var bestScore = 0.0;
          for (final template in validTemplates) {
            final score = FaceBiometricsService.cosineSimilarity(
              template,
              sampleEmbedding,
            );
            bestScore = math.max(bestScore, score);
          }
          scorePerFrame.add(bestScore);
        }
      } finally {
        for (final temp in tempFrames) {
          _safeDeleteFile(temp);
        }
      }

      validFrames = scorePerFrame.length;
      if (scorePerFrame.length < _faceTuning.minimumVerificationSamples) {
        outcome = 'insufficient_quality';
        EasyLoading.dismiss();
        EasyLoading.showError(
          qualityIssues.isNotEmpty
              ? qualityIssues.first
              : 'Kualitas wajah belum cukup. Coba ulangi dengan posisi stabil.',
        );
        return false;
      }

      passedFrames = scorePerFrame
          .where((score) => score >= _faceTuning.minimumFaceSimilarity)
          .length;
      medianScore = _median(scorePerFrame);

      EasyLoading.dismiss();
      if (_isFaceDebugTelemetryEnabled) {
        final scores =
            scorePerFrame.map((x) => x.toStringAsFixed(4)).join(', ');
        print(
          '[FACE] frame scores=[$scores], median=${medianScore.toStringAsFixed(4)}, passed=$passedFrames/${scorePerFrame.length}, threshold=${_faceTuning.minimumFaceSimilarity.toStringAsFixed(3)}',
        );
      }

      if (passedFrames < _faceTuning.minimumVerificationMatches ||
          medianScore < _faceTuning.minimumFaceSimilarity) {
        outcome = 'face_mismatch';
        EasyLoading.showError('Wajah tidak cocok. Coba lagi.');
        return false;
      }
      matched = true;
      outcome = 'matched';
      return true;
    } catch (e) {
      outcome =
          e is FaceBiometricsException ? 'biometric_exception' : 'verify_error';
      EasyLoading.dismiss();
      EasyLoading.showError(
        e is FaceBiometricsException ? e.message : 'Gagal verifikasi wajah',
      );
      return false;
    } finally {
      stopwatch.stop();
      _recordFaceTelemetry(
        _FaceVerificationTelemetry(
          timestamp: DateTime.now(),
          action: action,
          outcome: outcome,
          matched: matched,
          hasFaceData: hasFaceData,
          capturedFrames: capturedFrames,
          validFrames: validFrames,
          passedFrames: passedFrames,
          threshold: _faceTuning.minimumFaceSimilarity,
          medianScore: medianScore,
          scores: scorePerFrame,
          qualityIssues: qualityIssues,
          durationMs: stopwatch.elapsedMilliseconds,
          tuningProfile: _faceTuning.profile,
        ),
      );
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

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void onMapCameraMove(CameraPosition position) {
    mapZoom.value = position.zoom;
  }

  Future<void> focusMapToCurrentLocation() async {
    await _refreshCurrentLocationSilently();
    final mapController = _mapController;
    if (mapController == null) return;
    if (myLocation.latitude == 0 && myLocation.longitude == 0) return;

    final targetZoom = mapZoom.value.clamp(15.5, 20.0).toDouble();
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: myLocation, zoom: targetZoom),
      ),
    );
  }

  Future<void> zoomInMap() => _zoomMapBy(1.0);

  Future<void> zoomOutMap() => _zoomMapBy(-1.0);

  Future<void> _zoomMapBy(double delta) async {
    final mapController = _mapController;
    if (mapController == null) return;
    final nextZoom = (mapZoom.value + delta).clamp(3.0, 20.0).toDouble();
    mapZoom.value = nextZoom;
    await mapController.animateCamera(CameraUpdate.zoomTo(nextZoom));
  }

  Future<void> _refreshCurrentLocationSilently() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await _geolocatorPlatform.getCurrentPosition();
      myLocation = LatLng(position.latitude, position.longitude);
    } catch (_) {}
  }

  @override
  void onInit() async {
    super.onInit();
    _logFaceTuningConfig();
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
    serverFaceEmbeddings.clear();
    isFaceIdReady.value = false;
    isWithinAttendanceArea.value = false;
    markers.clear();
    determinePosition();
    await validateAttandance();
  }

  Future<void> validateAttandance() async {
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
      final firstData =
          (res?.data?.isNotEmpty ?? false) ? res!.data!.first : null;
      if (firstData == null) {
        serverFaceEmbeddings.clear();
        isFaceIdReady.value = false;
        isWithinAttendanceArea.value = false;
        distanceToOffice.value = '';
        officeLocation.value = null;
        isClockIn.value = false;
        _updateDuration();
        return;
      }

      userSchedule = firstData;
      serverFaceEmbeddings.assignAll(firstData.faceEmbeddings);
      isFaceIdReady.value = _extractValidServerEmbeddings().isNotEmpty;
      distanceToOffice.value = firstData.jarak?.toString() ?? '';
      isWithinAttendanceArea.value =
          _isInsideAttendanceArea(distanceToOffice.value) &&
              firstData.latitude != null &&
              firstData.longitude != null;

      LatLng _myOffice = LatLng(
        firstData.latitude ?? 0.0,
        firstData.longitude ?? 0.0,
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

      if (firstData.flag == "1") {
        isClockIn.value = true;
        if (firstData.absenIn != '') {
          // DateTime parseDateIn =
          //     DateTime.parse(res?.data?.first.absenIn.toString() ?? '');
          timeIn.value = firstData.absenIn.toString();
        }
        if (firstData.absenOut != '') {
          // DateTime parseDateOut =
          //     DateTime.parse(res?.data?.first.absenOut.toString() ?? '');
          // DateTime parseDateIn =
          //     DateTime.parse(res?.data?.first.absenIn.toString() ?? '');
          timeOut.value = firstData.absenOut.toString();
        }
      } else {
        isClockIn.value = false;
      }

      _updateDuration();
    } catch (e) {
      serverFaceEmbeddings.clear();
      isFaceIdReady.value = false;
      isWithinAttendanceArea.value = false;
      distanceToOffice.value = '';
      officeLocation.value = null;
      isClockIn.value = false;
      _updateDuration();
    }
  }

  Future<List<File>> _captureVerificationFrames({
    required File primaryFrame,
  }) async {
    final frames = <File>[primaryFrame];
    if (!faceCameraController.enableControls) {
      return frames;
    }

    try {
      await faceCameraController.stopImageStream();
      for (var i = 1; i < _faceTuning.verificationFrameCount; i++) {
        await Future.delayed(const Duration(milliseconds: 220));
        final xfile = await faceCameraController.takePicture();
        if (xfile == null) continue;
        final file = File(xfile.path);
        if (!await file.exists()) continue;
        frames.add(file);
      }
    } catch (_) {}
    return frames;
  }

  Future<String?> _faceQualityIssue(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        return 'Gagal membaca foto wajah. Coba ulangi.';
      }

      final oriented = img.bakeOrientation(decoded);
      final sampleW = math.min(96, oriented.width);
      final sampleH = math.min(96, oriented.height);
      if (sampleW < 24 || sampleH < 24) {
        return 'Resolusi foto terlalu kecil. Coba ulangi.';
      }

      final sampled = img.copyResize(
        oriented,
        width: sampleW,
        height: sampleH,
        interpolation: img.Interpolation.average,
      );
      final luminance = List<double>.filled(sampleW * sampleH, 0.0);
      var sumBrightness = 0.0;

      for (var y = 0; y < sampleH; y++) {
        for (var x = 0; x < sampleW; x++) {
          final pixel = sampled.getPixel(x, y);
          final value =
              (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b) / 255.0;
          final idx = (y * sampleW) + x;
          luminance[idx] = value;
          sumBrightness += value;
        }
      }

      final meanBrightness = sumBrightness / luminance.length;
      if (meanBrightness < _faceTuning.minimumBrightness) {
        return 'Foto terlalu gelap. Cari cahaya yang lebih terang.';
      }
      if (meanBrightness > _faceTuning.maximumBrightness) {
        return 'Foto terlalu terang. Hindari cahaya langsung ke wajah.';
      }

      var gradient = 0.0;
      var count = 0;
      for (var y = 1; y < sampleH; y++) {
        for (var x = 1; x < sampleW; x++) {
          final idx = (y * sampleW) + x;
          gradient += (luminance[idx] - luminance[idx - 1]).abs();
          gradient += (luminance[idx] - luminance[idx - sampleW]).abs();
          count += 2;
        }
      }

      final sharpness = count == 0 ? 0.0 : gradient / count;
      if (sharpness < _faceTuning.minimumSharpness) {
        return 'Foto blur. Tahan ponsel lebih stabil lalu ulangi.';
      }

      return null;
    } catch (_) {
      return 'Kualitas foto tidak bisa divalidasi. Coba ulangi.';
    }
  }

  bool _isInsideAttendanceArea(String? rawDistance) {
    final meters = _parseDistanceMeters(rawDistance);
    if (meters == null) return false;
    return meters <= _faceTuning.attendanceRadiusMeters;
  }

  double? _parseDistanceMeters(String? rawDistance) {
    final raw = (rawDistance ?? '').trim().toLowerCase();
    if (raw.isEmpty) return null;

    final normalized = raw.replaceAll(',', '.');
    final match = RegExp(r'-?\d+(\.\d+)?').firstMatch(normalized);
    if (match == null) return null;
    final parsed = double.tryParse(match.group(0)!);
    if (parsed == null) return null;
    if (normalized.contains('km')) {
      return parsed * 1000.0;
    }
    return parsed;
  }

  double _median(List<double> values) {
    if (values.isEmpty) return 0.0;
    final sorted = List<double>.from(values)..sort();
    final mid = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[mid];
    return (sorted[mid - 1] + sorted[mid]) / 2.0;
  }

  void _safeDeleteFile(File file) {
    try {
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (_) {}
  }

  bool get _isFaceDebugTelemetryEnabled =>
      kDebugMode || _faceDebugTelemetryFlag;

  List<Map<String, dynamic>> get recentFaceTelemetryLogs =>
      List<Map<String, dynamic>>.unmodifiable(faceTelemetryLogs);

  void clearFaceTelemetryLogs() {
    faceTelemetryLogs.clear();
  }

  void _recordFaceTelemetry(_FaceVerificationTelemetry entry) {
    if (!_isFaceDebugTelemetryEnabled) return;

    faceTelemetryLogs.add(entry.toJson());
    if (faceTelemetryLogs.length > _maxFaceTelemetryEntries) {
      final removeCount = faceTelemetryLogs.length - _maxFaceTelemetryEntries;
      faceTelemetryLogs.removeRange(0, removeCount);
    }

    print('[FACE_TELEMETRY] ${jsonEncode(entry.toJson())}');
  }

  void _logFaceTuningConfig() {
    if (!_isFaceDebugTelemetryEnabled) return;
    print('[FACE_TUNING] ${jsonEncode(_faceTuning.toJson())}');
  }

  static _FaceTuningConfig _buildFaceTuningConfig() {
    final profile = _tuningProfileRaw.trim().toLowerCase();
    var config = switch (profile) {
      'strict' => const _FaceTuningConfig(
          profile: 'strict',
          minimumFaceSimilarity: 0.82,
          verificationFrameCount: 4,
          minimumVerificationSamples: 3,
          minimumVerificationMatches: 3,
          minimumSharpness: 0.025,
          minimumBrightness: 0.22,
          maximumBrightness: 0.88,
          attendanceRadiusMeters: 150,
        ),
      'relaxed' => const _FaceTuningConfig(
          profile: 'relaxed',
          minimumFaceSimilarity: 0.75,
          verificationFrameCount: 3,
          minimumVerificationSamples: 2,
          minimumVerificationMatches: 2,
          minimumSharpness: 0.015,
          minimumBrightness: 0.17,
          maximumBrightness: 0.93,
          attendanceRadiusMeters: 150,
        ),
      _ => const _FaceTuningConfig(
          profile: 'balanced',
          minimumFaceSimilarity: 0.80,
          verificationFrameCount: 3,
          minimumVerificationSamples: 2,
          minimumVerificationMatches: 2,
          minimumSharpness: 0.018,
          minimumBrightness: 0.16,
          maximumBrightness: 0.94,
          attendanceRadiusMeters: 150,
        ),
    };

    final tuned = config.copyWith(
      minimumFaceSimilarity: _parseOptionalDouble(
        _minimumFaceSimilarityRaw,
        fallback: config.minimumFaceSimilarity,
        min: 0.55,
        max: 0.95,
      ),
      verificationFrameCount: _parseOptionalInt(
        _verificationFrameCountRaw,
        fallback: config.verificationFrameCount,
        min: 2,
        max: 6,
      ),
      minimumVerificationSamples: _parseOptionalInt(
        _minimumVerificationSamplesRaw,
        fallback: config.minimumVerificationSamples,
        min: 2,
        max: 6,
      ),
      minimumVerificationMatches: _parseOptionalInt(
        _minimumVerificationMatchesRaw,
        fallback: config.minimumVerificationMatches,
        min: 1,
        max: 6,
      ),
      minimumSharpness: _parseOptionalDouble(
        _minimumSharpnessRaw,
        fallback: config.minimumSharpness,
        min: 0.005,
        max: 0.10,
      ),
      minimumBrightness: _parseOptionalDouble(
        _minimumBrightnessRaw,
        fallback: config.minimumBrightness,
        min: 0.0,
        max: 1.0,
      ),
      maximumBrightness: _parseOptionalDouble(
        _maximumBrightnessRaw,
        fallback: config.maximumBrightness,
        min: 0.0,
        max: 1.0,
      ),
      attendanceRadiusMeters: _parseOptionalDouble(
        _attendanceRadiusMetersRaw,
        fallback: config.attendanceRadiusMeters,
        min: 10.0,
        max: 5000.0,
      ),
    );

    final frameCount = math.max(2, tuned.verificationFrameCount);
    final minSamples = tuned.minimumVerificationSamples.clamp(2, frameCount);
    final minMatches = tuned.minimumVerificationMatches.clamp(1, minSamples);
    var minBrightness = tuned.minimumBrightness.clamp(0.0, 1.0);
    var maxBrightness = tuned.maximumBrightness.clamp(0.0, 1.0);
    if (maxBrightness <= minBrightness) {
      maxBrightness = math.min(1.0, minBrightness + 0.1);
      if (maxBrightness <= minBrightness) {
        minBrightness = math.max(0.0, maxBrightness - 0.1);
      }
    }

    return tuned.copyWith(
      verificationFrameCount: frameCount,
      minimumVerificationSamples: minSamples,
      minimumVerificationMatches: minMatches,
      minimumBrightness: minBrightness,
      maximumBrightness: maxBrightness,
    );
  }

  static double _parseOptionalDouble(
    String raw, {
    required double fallback,
    required double min,
    required double max,
  }) {
    final normalized = raw.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return fallback;
    final parsed = double.tryParse(normalized);
    if (parsed == null) return fallback;
    return parsed.clamp(min, max).toDouble();
  }

  static int _parseOptionalInt(
    String raw, {
    required int fallback,
    required int min,
    required int max,
  }) {
    final normalized = raw.trim();
    if (normalized.isEmpty) return fallback;
    final parsed = int.tryParse(normalized);
    if (parsed == null) return fallback;
    return parsed.clamp(min, max).toInt();
  }

  List<List<double>> _extractValidServerEmbeddings({int? expectedLength}) {
    return serverFaceEmbeddings.where((template) {
      if (!ValidateData.isValidEmbedding(
        template,
        minLength: _minimumFaceEmbeddingLength,
      )) {
        return false;
      }
      if (expectedLength != null && template.length != expectedLength) {
        return false;
      }
      return true;
    }).toList(growable: false);
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
  void onClose() {
    _mapController?.dispose();
    _mapController = null;
    super.onClose();
  }
}

class _FaceTuningConfig {
  const _FaceTuningConfig({
    required this.profile,
    required this.minimumFaceSimilarity,
    required this.verificationFrameCount,
    required this.minimumVerificationSamples,
    required this.minimumVerificationMatches,
    required this.minimumSharpness,
    required this.minimumBrightness,
    required this.maximumBrightness,
    required this.attendanceRadiusMeters,
  });

  final String profile;
  final double minimumFaceSimilarity;
  final int verificationFrameCount;
  final int minimumVerificationSamples;
  final int minimumVerificationMatches;
  final double minimumSharpness;
  final double minimumBrightness;
  final double maximumBrightness;
  final double attendanceRadiusMeters;

  _FaceTuningConfig copyWith({
    String? profile,
    double? minimumFaceSimilarity,
    int? verificationFrameCount,
    int? minimumVerificationSamples,
    int? minimumVerificationMatches,
    double? minimumSharpness,
    double? minimumBrightness,
    double? maximumBrightness,
    double? attendanceRadiusMeters,
  }) {
    return _FaceTuningConfig(
      profile: profile ?? this.profile,
      minimumFaceSimilarity:
          minimumFaceSimilarity ?? this.minimumFaceSimilarity,
      verificationFrameCount:
          verificationFrameCount ?? this.verificationFrameCount,
      minimumVerificationSamples:
          minimumVerificationSamples ?? this.minimumVerificationSamples,
      minimumVerificationMatches:
          minimumVerificationMatches ?? this.minimumVerificationMatches,
      minimumSharpness: minimumSharpness ?? this.minimumSharpness,
      minimumBrightness: minimumBrightness ?? this.minimumBrightness,
      maximumBrightness: maximumBrightness ?? this.maximumBrightness,
      attendanceRadiusMeters:
          attendanceRadiusMeters ?? this.attendanceRadiusMeters,
    );
  }

  Map<String, dynamic> toJson() => {
        'profile': profile,
        'minimumFaceSimilarity': minimumFaceSimilarity,
        'verificationFrameCount': verificationFrameCount,
        'minimumVerificationSamples': minimumVerificationSamples,
        'minimumVerificationMatches': minimumVerificationMatches,
        'minimumSharpness': minimumSharpness,
        'minimumBrightness': minimumBrightness,
        'maximumBrightness': maximumBrightness,
        'attendanceRadiusMeters': attendanceRadiusMeters,
      };
}

class _FaceVerificationTelemetry {
  const _FaceVerificationTelemetry({
    required this.timestamp,
    required this.action,
    required this.outcome,
    required this.matched,
    required this.hasFaceData,
    required this.capturedFrames,
    required this.validFrames,
    required this.passedFrames,
    required this.threshold,
    required this.medianScore,
    required this.scores,
    required this.qualityIssues,
    required this.durationMs,
    required this.tuningProfile,
  });

  final DateTime timestamp;
  final String action;
  final String outcome;
  final bool matched;
  final bool hasFaceData;
  final int capturedFrames;
  final int validFrames;
  final int passedFrames;
  final double threshold;
  final double medianScore;
  final List<double> scores;
  final List<String> qualityIssues;
  final int durationMs;
  final String tuningProfile;

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'action': action,
        'outcome': outcome,
        'matched': matched,
        'hasFaceData': hasFaceData,
        'capturedFrames': capturedFrames,
        'validFrames': validFrames,
        'passedFrames': passedFrames,
        'threshold': threshold,
        'medianScore': medianScore,
        'scores': List<double>.from(scores),
        'qualityIssues': List<String>.from(qualityIssues.take(5)),
        'durationMs': durationMs,
        'tuningProfile': tuningProfile,
      };
}
