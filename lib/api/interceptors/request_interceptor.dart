import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:sales/api/api_constants.dart';
import 'package:sales/shared/constants/colors.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:sales/shared/utils/size_config.dart';
import 'package:sales/shared/widgets/button.dart';

import 'loading_tracker.dart';

FutureOr<Request?> requestInterceptor(Request request) async {
  // Tambahkan header dasar
  request.headers['X-Requested-With'] = 'XMLHttpRequest';
  // var prefs = Get.find<SharedPreferences>();
  // final token = prefs.getString('token') ?? "";
  // request.headers['Authorization'] = 'Bearer $token';

  bool isFakeLocation = false;
  try {
    isFakeLocation = await DetectFakeLocation().detectFakeLocation();
    // isFakeLocation = false;
  } catch (e) {
    isFakeLocation = false;
  }
  if (isFakeLocation) {
    Future.delayed(Duration.zero, () {
      Get.dialog(
        AlertDialog(
          title: CommonWidget.bodyText(text: 'Fake Location Terdeteksi'),
          content: CommonWidget.subtitleMultilineText(
              text: 'Matikan aplikasi lokasi palsu untuk melanjutkan.'),
          actions: [
            CustomButton(
              buttonColor: ColorConstants.mainColor,
              buttonText: 'KELUAR',
              width: SizeConfig().screenWidth,
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        barrierDismissible: false,
      );
    });
    return null;
  }

  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    Future.delayed(Duration.zero, () {
      EasyLoading.showError("Tidak ada koneksi internet");
    });
    return null; // Batalkan request
  }

  // Catatan: pengecekan DNS `google.com` sering flaky/blocked di beberapa jaringan
  // sehingga request jadi "timeout" padahal API bisa diakses.
  // Jika lookup gagal, biarkan request tetap jalan dan biarkan layer HTTP yang menangani.
  try {
    final host = Uri.parse(ApiConstants.baseUrl).host;
    await InternetAddress.lookup(host).timeout(const Duration(seconds: 2));
  } catch (_) {}

  if (LoadingTracker.shouldShow(request)) LoadingTracker.begin(request);
  return request;
}
