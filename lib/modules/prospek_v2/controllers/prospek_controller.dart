import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/user_id_request.dart';
import 'package:staffku/models/response/prospek_v2/detail_prospek_v2_response.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProspekV2Controller extends GetxController {
  final ApiRepository apiRepository;
  ProspekV2Controller({required this.apiRepository});

  var listProspek = <ProspekDetailV2>[].obs;
  final argm = Get.arguments;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;
  RxString status = "".obs;
  DateTime? selectedDate;

  RxInt page = 1.obs;
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  RxString monthLabel = "".obs;

  void onLoading() async {
    page.value = page.value + 1;
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    getProspek(page.value);
    refreshController.loadComplete();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();

    getProspek(page.value);
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
    token.value = prefs.getString('token') ?? "";
    userId.value = prefs.getString('userId') ?? "";
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getProspek(page) async {
    final res = await apiRepository.listProspekV2(
      UserIdRequest(id: userId.value, page: page.toString(), limit: '10'),
    );
    listProspek.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listProspek.clear();
    page.value = 1;
    getProspek(page.value);
    refreshController.refreshCompleted();
  }

  Future<void> _reloadFirstPage() async {
    listProspek.clear();
    page.value = 1;
    getProspek(page.value);
  }

  Future<void> goToDetailPages({ProspekDetailV2? dataProspect}) async {
    final result = await Get.toNamed(
      Routes.ADD_PROSPEK_V2,
      arguments: {'data_lead': dataProspect},
    );
    if (result == true) {
      await _reloadFirstPage();
    }
  }

  void goToAddPages() async {
    var result = await Get.toNamed(Routes.ADD_PROSPEK_V2);
    if (result == true) {
      await _reloadFirstPage();
    }
  }
}
