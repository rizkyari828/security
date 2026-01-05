import 'package:intl/intl.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/overtime/get_list.dart';
import 'package:staffku/models/response/prospek/list.dart';
import 'package:staffku/models/response/prospek/master_status_response.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProspekController extends GetxController {
  final ApiRepository apiRepository;
  ProspekController({required this.apiRepository});

  var listProspek = <ListProspek>[].obs;
  final argm = Get.arguments;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString userId = "".obs;
  RxString token = "".obs;
  RxString status = "".obs;
  DateTime? selectedDate;
  RxString monthV = DateFormat(
    "MMMM yyyy",
    "id_ID",
  ).format(DateTime.now()).toString().obs;
  RxString monthSubmit = DateFormat(
    "MM",
    "id_ID",
  ).format(DateTime.now()).toString().obs;
  RxInt page = 1.obs;
  RxString type = "".obs;
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  RxString monthLabel = "".obs;
  var masterStatus = <MasterStatus>[].obs;
  var listStatusOrder = <MasterStatus>[].obs;

  void onLoading() async {
    page.value = page.value + 1;
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    getProspek(page.value);
    getMasterStatusProspek();
    refreshController.loadComplete();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadUsers();
    getMasterStatusProspek();
    type.value = argm['type'].toString();
    status.value = argm['status'].toString();

    getProspek(page.value);
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

  void getProspek(page) async {
    String _month = DateFormat(
      "MM",
      "id_ID",
    ).format(selectedDate ?? DateTime.now()).toString();

    if (selectedDate != null) {
      _month = _month;
    } else {
      if (argm['month'].toString() == '') {
        _month = DateFormat(
          "MM",
          "id_ID",
        ).format(selectedDate ?? DateTime.now()).toString();
      } else {
        _month = argm['month'].toString();
      }
    }

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy');
    String formattedDateS = formatter.format(now);
    var dateString = _month + ', ' + formattedDateS;
    DateFormat format = new DateFormat("MM, yyyy");
    var formattedDate = format.parse(dateString);
    monthLabel.value = DateFormat(
      "MMMM yyyy",
      "id_ID",
    ).format(formattedDate).toString();

    final res = await apiRepository.listProspek(
      GetListRequest(
        id: userId.value,
        token: token.value,
        month: _month,
        status: status.value,
        type: type.value,
      ),
      page: page,
    );
    listProspek.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listProspek.clear();
    page.value = 1;
    getProspek(page.value);
    refreshController.refreshCompleted();
  }

  void getMasterStatusProspek() async {
    final res = await apiRepository.getMasterStatus();
    final data = res?.data;
    if (data == null || data.isEmpty) return;

    masterStatus.value = data;
    // for (var element in masterStatus) {
    listStatusOrder.add(MasterStatus(id: 0, namaCat: "All"));
    listStatusOrder.addAll(data);

    // }
  }

  void goToDetailPages({String id = ""}) {
    Get.toNamed(Routes.DETAIL_PROSPEK, arguments: id);
  }

  void goToAddPages() {
    Get.toNamed(Routes.ADD_PROSPEK);
  }
}
