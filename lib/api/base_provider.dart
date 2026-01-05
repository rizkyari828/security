import 'package:get/get.dart';

import 'api.dart';

class BaseProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.timeout = Duration(seconds: 120);
    httpClient.sendUserAgent = true;
    httpClient.userAgent = 'Staffku/1.0 (Flutter; GetConnect)';
    httpClient.addAuthenticator(authInterceptor);
    httpClient.addRequestModifier<dynamic>((request) async {
      final result = await requestInterceptor(request);
      // Jika null, batalkan request dengan throw
      if (result == null)
        throw Exception('Request dibatalkan karena tidak ada koneksi internet');
      return result;
    });
    httpClient.addResponseModifier(responseInterceptor);
  }
}
