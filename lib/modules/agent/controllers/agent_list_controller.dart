import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/user_id_request.dart';
import 'package:staffku/models/response/agent/list_agent_response.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentListController extends GetxController {
  final ApiRepository apiRepository;
  AgentListController({required this.apiRepository});

  var list = <DataAgent>[].obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;

  RxInt page = 1.obs;
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  void onLoading() async {
    page.value = page.value + 1;

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    getAgent(page.value);
    refreshController.loadComplete();
  }

  @override
  void onInit() {
    super.onInit();
    // getCnC();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();
    getAgent(page.value);
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

  void getAgent(page) async {
    final res = await apiRepository.listAgent(
      data: UserIdRequest(id: userId.value),
    );
    list.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    list.clear();
    page.value = 1;
    getAgent(page.value);
    refreshController.refreshCompleted();
  }

  Future<void> _reloadFirstPage() async {
    list.clear();
    page.value = 1;
    getAgent(page.value);
  }

  Future<void> goToDetailPages({DataAgent? dataAgent}) async {
    final result = await Get.toNamed(
      Routes.DETAIL_AGENT,
      arguments: {'data_lead': dataAgent},
    );
    if (result == true) {
      await _reloadFirstPage();
    }
  }

  void goToAddPages() async {
    var result = await Get.toNamed(Routes.ADD_AGENT);
    if (result == true) {
      await _reloadFirstPage();
    }
  }
}
