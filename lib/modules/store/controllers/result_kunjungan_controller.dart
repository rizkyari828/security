import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/user_id_request.dart';
import 'package:staffku/models/response/store/list_store.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultKunjunganController extends GetxController {
  final ApiRepository apiRepository;
  ResultKunjunganController({required this.apiRepository});

  var listStore = <DataStore>[].obs;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;

  RxInt page = 1.obs;
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  void goToKunjunganPages() {
    Get.toNamed(Routes.RESULT_KUNJUNGAN);
  }

  void onLoading() async {
    // page.value = page.value + 1;

    // // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // getStore(page.value);
    // refreshController.loadComplete();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();
    getStore(page.value);
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

  void getStore(page) async {
    final res = await apiRepository.listStore(
      page: page,
      data: UserIdRequest(id: userId.value),
    );
    listStore.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listStore.clear();
    page.value = 1;
    getStore(page.value);
    refreshController.refreshCompleted();
  }

  void goToDetailPages({String id = "", String storeName = ''}) {
    Get.toNamed(
      Routes.DETAIL_STORE,
      arguments: {'id': id, 'storeName': storeName},
    );
  }

  void goToAddPages() {
    Get.toNamed(Routes.ADD_LEAVE);
  }
}
