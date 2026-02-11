import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/modules/sos/models/sos_report.dart';
import 'package:staffku/routes/app_pages.dart';

class SosListController extends GetxController {
  SosListController({required this.apiRepository});

  final ApiRepository apiRepository;

  static const String _storageKey = 'sosReports';

  final RxList<SosReport> reports = <SosReport>[].obs;
  final RxBool isLoading = false.obs;

  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    loadReports(showLoading: true);
  }

  Future<void> loadReports({bool showLoading = false}) async {
    if (showLoading) isLoading.value = true;
    try {
      final box = GetStorage();
      final raw = box.read<List<dynamic>>(_storageKey) ?? <dynamic>[];
      final items = raw
          .whereType<Map>()
          .map((x) => SosReport.fromJson(Map<String, dynamic>.from(x)))
          .where((x) => x.id != 0)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      reports.assignAll(items);
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    await loadReports();
    refreshController.refreshCompleted();
  }

  void onLoading() {
    refreshController.loadNoData();
  }

  Future<void> addReport(SosReport report) async {
    reports.insert(0, report);
    await _persist();
  }

  Future<void> _persist() async {
    final box = GetStorage();
    box.write(
      _storageKey,
      reports.map((e) => e.toJson()).toList(growable: false),
    );
  }

  void goToAdd() async {
    final result = await Get.toNamed(Routes.ADD_SOS);
    if (result == true) {
      await loadReports(showLoading: false);
    }
  }

  void goToDetail({required int id}) {
    Get.toNamed(Routes.DETAIL_SOS, arguments: id);
  }

  SosReport? findById(int id) {
    try {
      return reports.firstWhere((x) => x.id == id);
    } catch (_) {
      return null;
    }
  }
}

