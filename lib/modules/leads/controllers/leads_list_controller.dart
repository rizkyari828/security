import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/user_id_request.dart';
import 'package:staffku/models/response/Lead/list_lead_respone.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadsListController extends GetxController {
  final ApiRepository apiRepository;
  LeadsListController({required this.apiRepository});

  var list = <DataLead>[].obs;
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
    getLeads(page.value);
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
    getLeads(page.value);
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

  void getLeads(page) async {
    final res = await apiRepository.listLeads(
      data: UserIdRequest(id: userId.value, page: page.toString(), limit: '10'),
    );
    list.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    list.clear();
    page.value = 1;
    getLeads(page.value);
    refreshController.refreshCompleted();
  }

  void goToDetailPages({DataLead? dataLead}) {
    Get.toNamed(Routes.DETAIL_LEADS, arguments: {'data_lead': dataLead});
  }

  void goToAddPages() async {
    var result = await Get.toNamed(Routes.ADD_LEADS);
    if (result == true) {
      list.clear();
      page.value = 1;
      getLeads(page.value);
    }
  }
}
