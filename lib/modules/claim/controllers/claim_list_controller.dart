import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/claim/list_claim_request.dart';
import 'package:staffku/models/response/claim/list_claim_response.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimListController extends GetxController {
  final ApiRepository apiRepository;
  ClaimListController({required this.apiRepository});

  var listClaim = <ClaimListItem>[].obs;
  RxString userId = ''.obs;
  final nominalPlafon = 0.obs;
  final sisaPlafon = 0.obs;
  final terpakaiPlafon = 0.obs;

  final isLoading = false.obs;

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    _init();
  }

  Future<void> _init() async {
    await _loadUsers();
    await fetchClaims(showLoading: true);
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    userId.value = prefs.getString('userId') ?? '';
  }

  Future<void> fetchClaims({bool showLoading = false}) async {
    final id = userId.value.trim();
    if (id.isEmpty) return;

    if (showLoading) isLoading.value = true;
    try {
      final res = await apiRepository.listClaim(
        data: ListClaimRequest(idUser: id),
      );

      nominalPlafon.value = res?.nominal ?? 0;
      sisaPlafon.value = res?.sisa ?? 0;
      terpakaiPlafon.value = res?.terpakai ?? 0;

      listClaim.assignAll(res?.data ?? []);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await fetchClaims();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    refreshController.loadNoData();
  }

  Future<void> _reload() async {
    await fetchClaims();
  }

  Future<void> goToDetailPages({String id = ''}) async {
    await Get.toNamed(Routes.DETAIL_CLAIM, arguments: id);
    await _reload();
  }

  void goToAddPages() async {
    final result = await Get.toNamed(Routes.ADD_CLAIM);
    if (result == true) {
      await fetchClaims(showLoading: true);
    }
  }
}
