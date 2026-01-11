import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/patroli/patroli_list_request.dart';
import 'package:staffku/models/response/patroli/patroli_list_response.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:staffku/routes/app_pages.dart';

class StoreListController extends BaseController {
  StoreListController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final listPatroli = <PatroliListItem>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() async {
    super.onReady();
    await loadUsers();
    await getPatroli();
  }

  Future<void> getPatroli() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final res = await apiRepository.listPatroli(
        PatroliListRequest(idUser: userId.value),
      );
      listPatroli.assignAll(res?.data ?? []);
    } catch (_) {
      listPatroli.clear();
      errorMessage.value = 'Gagal memuat jadwal patroli';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 700));
    await getPatroli();
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    await Future.delayed(const Duration(milliseconds: 700));
    refreshController.loadComplete();
  }

  void goToDetailPages(PatroliListItem item) async {
    final result = await Get.toNamed(
      Routes.DETAIL_STORE,
      arguments: {
        'id': item.id?.toString() ?? '',
        'id_jadwal': item.idJadwal?.toString() ?? '',
        'nama_jadwal': item.namaJadwal?.toString() ?? '',
        'status': item.status?.toString() ?? '',
      },
    );

    if (result == true) {
      await getPatroli();
    }
  }
}
