import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/id_request.dart';
import 'package:sales/models/response/recap_history.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sales/shared/utils/common_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecapController extends GetxController
    with StateMixin<List<DataHistory>> {
  final ApiRepository apiRepository;
  RecapController({required this.apiRepository});
  DateTime? initialDate;
  // List<DataHistory> _historyData = [];
  var historyData = <DataHistory>[].obs;
  DateTime? selectedDate;
  RxString month =
      DateFormat("MMMM yyyy", "id_ID").format(DateTime.now()).toString().obs;
  RxString monthSubmit =
      DateFormat("MM", "id_ID").format(DateTime.now()).toString().obs;
  // RxList<DataHistory> historyData = (List<DataHistory>.of([])).obs;
  // get historyData => this._historyData;
  // List<TableRow> priceTableRows = [];
  RxString idUser = "".obs;
  RxString token = "".obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // getData();
  }

  @override
  void onReady() async {
    super.onReady();
    await loadUsers();
    await getData();
  }

  Future<void> loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    token.value = prefs.getString('token') ?? "";
    idUser.value = prefs.getString('userId') ?? "";
  }

  @override
  void onClose() {
    historyData.value = [];
  }

  Future<void> getData() async {
    change(null, status: RxStatus.loading());
    historyData.clear();
    monthSubmit.value = DateFormat("MM", "id_ID")
        .format(selectedDate ?? DateTime.now())
        .toString();

    if (token.value.isEmpty || idUser.value.isEmpty) {
      CommonWidget.errorSnackBar(
          'Sesi login tidak valid. Silakan login ulang.');
      change(null, status: RxStatus.error('Sesi login tidak valid'));
      return;
    }

    final res = await apiRepository.getRecapHistory(IdRequest(
        id: idUser.value, token: token.value, month: monthSubmit.value));

    if (res == null) {
      CommonWidget.errorSnackBar('Gagal memuat rekap. Silakan coba lagi.');
      change(null, status: RxStatus.error('Gagal memuat rekap'));
      return;
    }

    if (res.error == true) {
      final message = (res.message ?? '').trim().isEmpty
          ? 'Gagal memuat rekap. Silakan coba lagi.'
          : res.message!;
      CommonWidget.errorSnackBar(message);
      change(null, status: RxStatus.error(message));
      return;
    }

    final items = res.data ?? const <DataHistory>[];
    historyData.addAll(items);
    if (items.isEmpty) {
      change(items, status: RxStatus.empty());
      return;
    }
    change(items, status: RxStatus.success());
  }
}
