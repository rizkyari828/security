import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/response/benefit/list_benefit.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController {
  final ApiRepository apiRepository;
  NotificationController({required this.apiRepository});

  var listCuti = <ListBenefit>[].obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;

  RxInt page = 1.obs;
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  void onLoading() async {
    page.value = page.value + 1;

    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    getCuti(page.value);
    refreshController.loadComplete();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getCuti(page.value);
    loadUsers();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getCuti(page) async {
    // final res = await apiRepository.listBenefit(page: page);
    // listCuti.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listCuti.clear();
    page.value = 1;
    getCuti(page.value);
    refreshController.refreshCompleted();
  }

  void goToDetailCutiPages({String id = ""}) {
    Get.toNamed(Routes.DETAIL_CUTI, arguments: id);
  }

  void goToAddCutiPages() {
    Get.toNamed(Routes.ADD_CUTI);
  }
}
