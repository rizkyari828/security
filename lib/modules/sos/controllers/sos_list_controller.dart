import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/sos/list_sos_request.dart';
import 'package:staffku/models/response/sos/list_sos_response.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SosListController extends GetxController {
  SosListController({required this.apiRepository});

  final ApiRepository apiRepository;

  final RxList<SosListItem> reports = <SosListItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString userId = ''.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() async {
    super.onReady();
    await _loadUsers();
    await loadReports(showLoading: true);
  }

  Future<bool> loadReports({bool showLoading = false}) async {
    final id = userId.value.trim();
    if (id.isEmpty) {
      reports.clear();
      hasError.value = true;
      errorMessage.value = 'User tidak valid, silakan login ulang';
      return false;
    }

    if (showLoading) isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    try {
      final res = await apiRepository.listSos(data: ListSosRequest(idUser: id));
      if (res == null) {
        hasError.value = true;
        errorMessage.value = 'Gagal memuat data SOS';
        return false;
      }

      if (res.error == true) {
        hasError.value = true;
        errorMessage.value = (res.message ?? '').trim().isEmpty
            ? 'Gagal memuat data SOS'
            : res.message!.trim();
        return false;
      }

      final data = (res.data ?? <SosListItem>[])
        ..sort((a, b) {
          final ad = a.cdate;
          final bd = b.cdate;
          if (ad == null && bd == null) return 0;
          if (ad == null) return 1;
          if (bd == null) return -1;
          return bd.compareTo(ad);
        });
      reports.assignAll(data);
      return true;
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    final success = await loadReports();
    if (success) {
      refreshController.refreshCompleted();
    } else {
      refreshController.refreshFailed();
    }
  }

  void onLoading() {
    refreshController.loadNoData();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    userId.value = prefs.getString('userId') ?? '';
  }

  void goToAdd() async {
    final result = await Get.toNamed(Routes.ADD_SOS);
    if (result == true) {
      await loadReports(showLoading: true);
    }
  }

  void goToDetail({required SosListItem item}) {
    Get.toNamed(Routes.DETAIL_SOS, arguments: item);
  }
}
