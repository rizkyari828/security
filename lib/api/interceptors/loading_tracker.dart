import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_connect/http/src/request/request.dart';

class LoadingTracker {
  static const String headerKey = 'X-Show-Loading';
  static int _inflight = 0;

  static bool shouldShow(Request request) {
    final method = request.method.toUpperCase();
    return method != 'GET';
  }

  static void begin(Request request) {
    request.headers[headerKey] = '1';
    _inflight += 1;
    if (!EasyLoading.isShow) {
      EasyLoading.show(status: 'loading..');
    }
  }

  static void end(Request request) {
    if (request.headers[headerKey] != '1') return;
    if (_inflight > 0) _inflight -= 1;
    if (_inflight == 0) {
      EasyLoading.dismiss();
    }
  }
}

