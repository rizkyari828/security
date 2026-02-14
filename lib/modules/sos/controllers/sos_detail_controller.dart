import 'package:get/get.dart';
import 'package:staffku/models/response/sos/list_sos_response.dart';

class SosDetailController extends GetxController {
  final Rxn<SosListItem> report = Rxn<SosListItem>();

  @override
  void onReady() {
    super.onReady();
    final arg = Get.arguments;
    if (arg is SosListItem) {
      report.value = arg;
      return;
    }
    if (arg is Map) {
      report.value = SosListItem.fromJson(Map<String, dynamic>.from(arg));
    }
  }
}
