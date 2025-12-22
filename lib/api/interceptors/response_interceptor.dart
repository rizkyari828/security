import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sales/models/models.dart';
import 'package:sales/routes/routes.dart';
import 'package:sales/shared/shared.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_tracker.dart';

FutureOr<Response> responseInterceptor(Request request, Response response) async {
  print(request.url);
  print(response.body);

  if (response.statusCode == -1) {
    EasyLoading.showError('Tidak ada koneksi internet');
    LoadingTracker.end(request);
    return response;
  }

  if (response.statusCode == 200) {
    try {
      final message = ErrorResponse.fromJson(response.body);
      if (message.error == true) {
        EasyLoading.showError(message.message ?? '');
        LoadingTracker.end(request);
        return response;
      }
    } catch (e) {
      // Catch jika parsing gagal
      print("Parsing ErrorResponse gagal: $e");
    }
  } else {
    print(response.statusCode);
    handleErrorStatus(response);
  }

  LoadingTracker.end(request);
  return response;
}

void handleErrorStatus(Response response) {
  try {
    final message = ErrorResponse.fromJson(response.body);

    if (message.error == true) {
      EasyLoading.showError(message.message ?? '');
    } else if (response.statusCode == 400) {
      CommonWidget.errorSnackBar(message.message ?? '');
    } else if (response.statusCode == 401) {
      CommonWidget.errorSnackBar(message.message ?? '');
      if (message.message == 'Unauthenticated.') {
        var storage = Get.find<SharedPreferences>();
        storage.clear();
        Get.offAllNamed(Routes.LOGIN);
      }
    } else if (response.statusCode == 404) {
      if (message.message != 'Data rating belum tersedia') {
        CommonWidget.errorSnackBar(message.message ?? '');
      }
    } else if (response.statusCode == 403) {
      if (message.message != 'Hanya client yg bisa memberika rating') {
        CommonWidget.errorSnackBar(message.message ?? '');
      }
    } else if (response.statusCode == 422) {
      CommonWidget.errorSnackBar(message.message ?? '');
    } else {
      EasyLoading.showError('Terjadi kesalahan. Silakan coba lagi nanti');
    }
  } catch (e) {
    EasyLoading.showError('Terjadi kesalahan saat memproses data');
    print("Parsing error di handleErrorStatus: $e");
  }
}
