import 'package:get/get.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/modules/sos/controllers/sos_list_controller.dart';
import 'package:staffku/modules/sos/models/sos_report.dart';

class SosDetailController extends GetxController {
  SosDetailController({required this.apiRepository});

  final ApiRepository apiRepository;

  final Rxn<SosReport> report = Rxn<SosReport>();

  @override
  void onReady() {
    super.onReady();
    final arg = Get.arguments;
    final id = arg is int ? arg : int.tryParse(arg?.toString() ?? '');
    if (id == null) return;
    report.value = Get.find<SosListController>().findById(id);
  }
}

