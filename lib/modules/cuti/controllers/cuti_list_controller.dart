import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/user_id_request.dart';
import 'package:staffku/models/response/cuti_sales/list_cuti_sales.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CutiListController extends GetxController {
  final ApiRepository apiRepository;
  CutiListController({required this.apiRepository});

  var listCuti = <DataCutiSales>[].obs;
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
    getCutiSales(page.value);
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
    getCutiSales(page.value);
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

  void getCutiSales(page) async {
    final res = await apiRepository.listCuti(
      data: UserIdRequest(id: userId.value, page: page.toString(), limit: '10'),
    );
    listCuti.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listCuti.clear();
    page.value = 1;
    getCutiSales(page.value);
    refreshController.refreshCompleted();
  }

  void goToDetailPages({String id = ""}) {
    Get.toNamed(Routes.DETAIL_CUTI_SALES, arguments: id);
  }

  void goToAddPages() async {
    var result = await Get.toNamed(Routes.ADD_CUTI_SALES);
    if (result == true) {
      // Refresh data jika submit sukses
      listCuti.clear();
      page.value = 1;
      getCutiSales(page.value);
    }
  }
}
