import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/id_request.dart';
import 'package:staffku/models/response/izin/list_izin.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveListController extends BaseController {
  LeaveListController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  var listIzin = <DataIzin>[].obs;
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
    getIzin(page.value);
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
    getIzin(page.value);
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

  Future<void> getIzin(page) async {
    final res = await apiRepository.listIzin(
      page: page,
      data: IdRequest(id: userId.value, token: token.value),
    );
    listIzin.addAll(res?.data ?? []);
  }

  Future<void> _reloadFirstPage() async {
    listIzin.clear();
    page.value = 1;
    await getIzin(page.value);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    await _reloadFirstPage();
    refreshController.refreshCompleted();
  }

  Future<void> goToDetailPages({String id = ""}) async {
    await Get.toNamed(Routes.DETAIL_LEAVE, arguments: id);
    await _reloadFirstPage();
  }

  Future<void> goToAddPages() async {
    final result = await Get.toNamed(Routes.ADD_LEAVE);
    if (result == true) {
      await _reloadFirstPage();
    }
  }
}
