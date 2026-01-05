import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/attendance/attendance_wrapper.dart';
import 'package:staffku/models/request/kunjungan/non_schedule_request.dart';
import 'package:staffku/shared/constants/colors.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/utils/size_config.dart';
import 'package:flutter_network_monitor/flutter_network_monitor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseController extends GetxController {
  final ApiRepository apiRepository;
  BaseController({required this.apiRepository});

  RxBool isConnectedToInternet = true.obs;
  RxBool isConnectedToInternetWidget = false.obs;

  final connectionMonitor = ConnectionTypeMonitor();

  ConnectionQuality quality = ConnectionQuality.moderate;

  RxString qualityNetwork = "".obs;

  RxString name = "".obs;
  RxString idPegawai = "".obs;
  RxString userId = "".obs;
  RxString profilePhoto = "".obs;
  RxString username = "".obs;
  RxString token = "".obs;
  RxString tipeUser = "".obs;
  RxString groupId = "".obs;

  RxBool showInputError = false.obs;

  RxBool menuKunjungan = false.obs;
  RxBool menuLeads = false.obs;
  RxBool menuProspek = false.obs;
  RxBool menuAgent = false.obs;
  RxBool menuBenefit = false.obs;
  RxBool menuLembur = false.obs;
  RxBool menuCuti = false.obs;
  RxBool menuKuisioner = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _checkDownloadSpeed();
    Connectivity().onConnectivityChanged.listen((result) {
      _handleCheckConnectivity(result.first);
      _checkDownloadSpeed();
    });
  }

  @override
  void onReady() {
    super.onReady();
    if (isConnectedToInternet.value == false) {
      qualityNetwork.value = 'no internet';
    } else {
      Timer.periodic(Duration(minutes: 2), (timer) {
        _checkDownloadSpeed();
      });
    }
    loadUsers();
  }

  final speedTest = SpeedTest();

  void _checkDownloadSpeed() async {
    try {
      double speed = await speedTest.testDownloadSpeed();
      print('Download Speed: ${speed.toStringAsFixed(2)} Mbps');

      quality = ConnectionQualityDeterminer.determineQuality(speed);
      qualityNetwork.value = quality.name;

      print(
        'Connection Quality: ${ConnectionQualityDeterminer.getQualityString(quality)}',
      );
    } catch (e) {
      qualityNetwork.value = 'no internet';
    }
  }

  void _handleCheckConnectivity(ConnectivityResult result) async {
    try {
      if (result == ConnectivityResult.none) {
        isConnectedToInternet.value = false;
        isConnectedToInternetWidget.value = true;
      } else {
        final connection = await InternetAddress.lookup('google.com');
        if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
          isConnectedToInternet.value = true;
          isConnectedToInternetWidget.value = true;

          // await submitPendingAttendance();
        }
      }
    } on SocketException catch (_) {
      isConnectedToInternet.value = false;
      isConnectedToInternetWidget.value = true;
    }
  }

  Widget internetConnection() {
    final sw = SizeConfig().screenWidth;
    final sh = SizeConfig().screenHeight;
    return isConnectedToInternet.value == false
        ? Container(
            width: sw,
            height: sw * .18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey[300] ?? ColorConstants.white, // Border color
                width: 1, // Border width
              ),
              boxShadow: [
                BoxShadow(
                  color: CommonWidget.setOpacity(Colors.black, 0.3),
                  blurRadius: 20.0,
                  spreadRadius: 4.0,
                  offset: Offset(-10.0, 10.0),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: sh / 20, left: 10.0, right: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          width: 40, // Diameter lingkaran
                          height: 40,
                          decoration: BoxDecoration(
                            color: isConnectedToInternet.value == false
                                ? Colors.grey[400]
                                : Colors.green, // Warna latar lingkaran
                            shape: BoxShape.circle, // Membuat bentuk lingkaran
                          ),
                          child: isConnectedToInternet.value == false
                              ? Icon(
                                  Icons.wifi_off,
                                  size: 25.0, // Ukuran ikon
                                  color: Colors.white, // Warna ikon
                                )
                              : Icon(
                                  Icons.wifi,
                                  size: 25.0, // Ukuran ikon
                                  color: Colors.white,
                                ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isConnectedToInternet.value == false
                                ? CommonWidget.subtitleText(
                                    text: "Internet Terputus",
                                    color: ColorConstants.black,
                                    fontWeight: FontWeight.bold,
                                  )
                                : CommonWidget.subtitleText(
                                    text: "Internet Tersambung",
                                    color: ColorConstants.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            isConnectedToInternet.value == false
                                ? CommonWidget.subtitleText(
                                    text: "Segera periksa jaringan internet mu",
                                    color: ColorConstants.black,
                                  )
                                : CommonWidget.subtitleText(
                                    text: "Kamu Terkoneksi dengan internet",
                                    color: ColorConstants.black,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => closeWidget(),
                    child: Container(
                      width: 30, // Diameter lingkaran
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, size: 20.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  // Ubah dari private ke public agar bisa diakses dari widget
  Future<void> submitPendingAttendance() async {
    final storage = GetStorage();
    final dataList = storage.read<List<dynamic>>('pendingAttendance');

    if (dataList == null || dataList.isEmpty) return;

    final List<Map<String, dynamic>> updatedList =
        List<Map<String, dynamic>>.from(dataList);

    final List<Map<String, dynamic>> failedToSubmit = [];

    for (final data in updatedList) {
      try {
        final wrapper = AttendanceSubmitRequestWrapper.fromJson(data);
        bool success = false;
        if (wrapper.type == 'schedule') {
          success = await _submitAttendance(wrapper);
        } else {
          success = await _nonSubmitAttendance(wrapper);
        }

        if (!success) {
          failedToSubmit.add(data);
        }
      } catch (e) {
        print('Error parsing pending attendance: $e');
        failedToSubmit.add(data);
      }
    }

    if (failedToSubmit.isEmpty) {
      storage.remove('pendingAttendance');
      EasyLoading.showSuccess("Semua data tertunda berhasil dikirim");
    } else {
      storage.write('pendingAttendance', failedToSubmit);
      EasyLoading.showInfo("${failedToSubmit.length} data masih gagal dikirim");
    }
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

  Future<bool> _nonSubmitAttendance(
    AttendanceSubmitRequestWrapper wrapper,
  ) async {
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

  void closeWidget() {
    isConnectedToInternetWidget.value = false;
  }

  int get pendingAttendanceCount {
    final storage = GetStorage();
    final dataList = storage.read<List<dynamic>>('pendingAttendance');
    if (dataList == null) return 0;
    return dataList.length;
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    name.value = prefs.getString('name') ?? "";
    idPegawai.value = prefs.getString('idPegawai') ?? "";
    userId.value = prefs.getString('userId') ?? "";
    profilePhoto.value = prefs.getString('profilePhoto') ?? "";
    username.value = prefs.getString('username') ?? "";
    token.value = prefs.getString('token') ?? "";
    userId.value = prefs.getString('userId') ?? "";
    tipeUser.value = prefs.getString('tipe') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";

    menuKunjungan.value = prefs.getBool('menu_kunjungan') ?? false;
    menuLeads.value = prefs.getBool('menu_leads') ?? false;
    menuProspek.value = prefs.getBool('menu_prospek') ?? false;
    menuAgent.value = prefs.getBool('menu_agent') ?? false;
    menuBenefit.value = prefs.getBool('menu_benefit') ?? false;
    menuLembur.value = prefs.getBool('menu_lembur') ?? false;
    menuCuti.value = prefs.getBool('menu_cuti') ?? false;
    menuKuisioner.value = prefs.getBool('menu_kuisioner') ?? false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
