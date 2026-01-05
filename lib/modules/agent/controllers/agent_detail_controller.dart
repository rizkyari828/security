import 'package:staffku/api/api_repository.dart';
import 'package:get/get.dart';
import 'package:staffku/models/response/agent/list_agent_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentDetailController extends GetxController {
  final ApiRepository apiRepository;
  AgentDetailController({required this.apiRepository});

  final argm = Get.arguments;
  var detail = DataAgent().obs;
  String date = "";
  DateTime selectedDate = DateTime.now();
  RxString groupName = "".obs;
  RxString groupId = "".obs;

  RxList<Foto> imageFileList = (List<Foto>.of([])).obs;
  RxList<Foto> signatureFile = (List<Foto>.of([])).obs;

  RxString? retrieveDataError;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    detail.value = argm['data_lead'];
    // getDetailIzin();
    imageFileList.addAll(detail.value.foto ?? []);
    signatureFile.addAll(detail.value.signature ?? []);
    loadUsers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
  }
}
