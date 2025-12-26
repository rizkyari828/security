import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sales/models/models.dart';
import 'package:sales/routes/routes.dart';
import 'package:sales/shared/shared.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_tracker.dart';

FutureOr<Response> responseInterceptor(
  Request request,
  Response response,
) async {
  try {
    if (kDebugMode) {
      print(request.url);
      if (response.body != null) {
        print(response.body);
      }
    }

    if (response.statusCode == -1) {
      if (_shouldNotify(request)) {
        EasyLoading.showError('Tidak ada koneksi internet');
      }
      return response;
    }

    if (response.statusCode == 200) {
      try {
        final message = ErrorResponse.fromJson(response.body);
        if (message.error == true) {
          if (_shouldNotify(request)) {
            EasyLoading.showError(message.message ?? '');
          }
          return response;
        }
      } catch (e) {
        if (kDebugMode) {
          print("Parsing ErrorResponse gagal: $e");
        }
      }
    } else {
      if (kDebugMode) {
        print(response.statusCode);
      }
      handleErrorStatus(request, response);
    }

    return response;
  } finally {
    LoadingTracker.end(request);
  }
}

bool _shouldNotify(Request request) {
  final method = request.method.toUpperCase();
  if (method != 'GET') return true;

  final showError = request.headers['X-Show-Error'] == '1';
  return showError;
}

void handleErrorStatus(Request request, Response response) {
  try {
    final message = ErrorResponse.fromJson(response.body);

    if (message.error == true) {
      if (_shouldNotify(request)) {
        EasyLoading.showError(message.message ?? '');
      }
    } else if (response.statusCode == 400) {
      if (_shouldNotify(request)) {
        CommonWidget.errorSnackBar(message.message ?? '');
      }
    } else if (response.statusCode == 401) {
      CommonWidget.errorSnackBar(message.message ?? '');
      if (message.message == 'Unauthenticated.') {
        var storage = Get.find<SharedPreferences>();
        storage.clear();
        Get.offAllNamed(Routes.LOGIN);
      }
    } else if (response.statusCode == 404) {
      if (_shouldNotify(request) &&
          message.message != 'Data rating belum tersedia') {
        CommonWidget.errorSnackBar(message.message ?? '');
      }
    } else if (response.statusCode == 403) {
      if (_shouldNotify(request) &&
          message.message != 'Hanya client yg bisa memberika rating') {
        CommonWidget.errorSnackBar(message.message ?? '');
      }
    } else if (response.statusCode == 422) {
      if (_shouldNotify(request)) {
        CommonWidget.errorSnackBar(message.message ?? '');
      }
    } else {
      if (_shouldNotify(request)) {
        EasyLoading.showError('Terjadi kesalahan. Silakan coba lagi nanti');
      }
    }
  } catch (e) {
    if (_shouldNotify(request)) {
      EasyLoading.showError('Terjadi kesalahan saat memproses data');
    }
    if (kDebugMode) {
      print("Parsing error di handleErrorStatus: $e");
    }
  }
}
