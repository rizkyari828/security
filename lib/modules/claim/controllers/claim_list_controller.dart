import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/user_id_request.dart';
import 'package:sales/models/response/claim/list_claim_response.dart';
import 'package:sales/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimListController extends GetxController {
  final ApiRepository apiRepository;
  ClaimListController({required this.apiRepository});

  var listClaim = <ClaimListItem>[].obs;
  RxString groupId = ''.obs;
  RxString userId = ''.obs;
  RxInt page = 1.obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onReady() {
    super.onReady();
    _loadUsers();
    getClaim(page.value);
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    groupId.value = prefs.getString('groupId') ?? '';
    userId.value = prefs.getString('userId') ?? '';
  }

  void getClaim(int page) async {
    final res = await apiRepository.listClaim(
      data: UserIdRequest(
        id: userId.value,
        page: page.toString(),
        limit: '10',
      ),
    );
    listClaim.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    listClaim.clear();
    page.value = 1;
    getClaim(page.value);
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    page.value = page.value + 1;
    await Future.delayed(const Duration(milliseconds: 1000));
    getClaim(page.value);
    refreshController.loadComplete();
  }

  void goToDetailPages({String id = ''}) {
    Get.toNamed(Routes.DETAIL_CLAIM, arguments: id);
  }

  void goToAddPages() async {
    final result = await Get.toNamed(Routes.ADD_CLAIM);
    if (result == true) {
      listClaim.clear();
      page.value = 1;
      getClaim(page.value);
    }
  }
}

