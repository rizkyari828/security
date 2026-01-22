import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/shift_swap/list_shift_request.dart';
import 'package:staffku/models/response/shift_swap/list_shift_response.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftSwapListController extends GetxController {
  final ApiRepository apiRepository;
  ShiftSwapListController({required this.apiRepository});

  var listShift = <ListShiftItem>[].obs;
  RxString groupId = ''.obs;
  RxString userId = ''.obs;
  RxBool isLoading = false.obs;

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() async {
    super.onReady();
    await _loadUsers();
    await fetchList();
  }

  Future<void> _loadUsers() async {
    final prefs = Get.find<SharedPreferences>();
    groupId.value = prefs.getString('groupId') ?? '';
    userId.value = prefs.getString('userId') ?? '';
  }

  Future<void> fetchList() async {
    isLoading.value = true;
    final res = await apiRepository.listShift(
      data: ListShiftRequest(idUser: userId.value),
    );
    listShift.assignAll(res?.data ?? []);
    isLoading.value = false;
  }

  Future<void> onRefresh() async {
    await fetchList();
    refreshController.refreshCompleted();
  }

  Future<void> goToDetailPages({required ListShiftItem item}) async {
    await Get.toNamed(
      Routes.DETAIL_SHIFT_SWAP,
      arguments: {
        'id': item.id?.toString() ?? '',
        'status': item.status ?? '',
        'nama': item.nama ?? '',
      },
    );
    await fetchList();
  }

  void goToAddPages() async {
    final result = await Get.toNamed(Routes.ADD_SHIFT_SWAP);
    if (result == true) {
      fetchList();
    }
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
