import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:detect_fake_location/detect_fake_location.dart';
import 'package:flutter/foundation.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_tracker.dart';

const Duration _preflightTimeout = Duration(seconds: 3);

bool _isAuthRequest(Request request) {
  final path = request.url.path.toLowerCase();
  return path.endsWith('/login') || path.endsWith('/register');
}

FutureOr<Request?> requestInterceptor(Request request) async {
  final stopwatch = Stopwatch()..start();

  // Tambahkan header dasar
  request.headers['X-Requested-With'] = 'XMLHttpRequest';
  request.headers['accept'] ??= 'application/json';

  if (!_isAuthRequest(request) &&
      !request.headers.containsKey('Authorization')) {
    try {
      if (Get.isRegistered<SharedPreferences>()) {
        final prefs = Get.find<SharedPreferences>();
        final token = (prefs.getString('token') ?? '').trim();
        if (token.isNotEmpty) {
          request.headers['Authorization'] = 'Bearer $token';
        }
      }
    } catch (_) {}
  }

  bool isFakeLocation = false;
  if (!_isAuthRequest(request)) {
    try {
      isFakeLocation = await DetectFakeLocation()
          .detectFakeLocation()
          .timeout(_preflightTimeout, onTimeout: () => false);
      // isFakeLocation = false;
    } catch (_) {
      isFakeLocation = false;
    }
  }
  if (kDebugMode) {
    print(
        '[HTTP][preflight] fakeLocation=$isFakeLocation ${request.method} ${request.url} (${stopwatch.elapsedMilliseconds}ms)');
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

  List<ConnectivityResult> result;
  try {
    result = await Connectivity().checkConnectivity().timeout(_preflightTimeout,
        onTimeout: () => const <ConnectivityResult>[ConnectivityResult.other]);
  } catch (_) {
    result = const <ConnectivityResult>[ConnectivityResult.other];
  }
  if (kDebugMode) {
    print(
        '[HTTP][preflight] connectivity=$result ${request.method} ${request.url} (${stopwatch.elapsedMilliseconds}ms)');
  }
  final isOffline =
      result.isEmpty || result.every((r) => r == ConnectivityResult.none);
  if (isOffline) {
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
  if (kDebugMode) {
    print(
        '[HTTP][preflight] dns-ok ${request.method} ${request.url} (${stopwatch.elapsedMilliseconds}ms)');
  }

  if (LoadingTracker.shouldShow(request)) LoadingTracker.begin(request);
  return request;
}
