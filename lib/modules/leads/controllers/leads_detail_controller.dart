import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sales/api/api_repository.dart';
import 'package:sales/models/request/leads/submit_status_lead.dart';
import 'package:sales/models/response/Lead/list_lead_respone.dart';
import 'package:get/get.dart';
import 'package:sales/models/response/master_data_2_response.dart';
import 'package:sales/models/response/prospek_v2/detail_prospek_v2_response.dart';
import 'package:sales/modules/home/base_controller.dart';
import 'package:sales/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadsDetailController extends BaseController {
  LeadsDetailController({required ApiRepository apiRepository})
      : super(apiRepository: apiRepository);

  final argm = Get.arguments;
  var detail = DataLead().obs;
  String date = "";
  DateTime selectedDate = DateTime.now();
  RxString groupName = "".obs;
  RxString groupId = "".obs;

  RxList<Foto> imageFileList = (List<Foto>.of([])).obs;

  RxString? retrieveDataError;
  var listStatusLead = <MasterData2>[].obs;
  var masterData = <MasterData2>[].obs;
  RxString statusLead = "".obs;
  RxInt statusLeadId = 0.obs;
  RxBool isEdit = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    detail.value = argm['data_lead'];
    statusLeadId.value = detail.value.idStatusLead ?? 0;
    statusLead.value = detail.value.statusLead ?? '';
    if (detail.value.statusLead.toString().toLowerCase() != 'prospek') {
      isEdit.value = true;
    }
    getMasterData();
    imageFileList.addAll(detail.value.foto ?? []);
    loadUsers();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getMasterData() async {
    masterData.clear();
    final resListStatusLead = await apiRepository.getMasterData2('Status Lead');
    final statusLeadData = resListStatusLead?.data;
    if (statusLeadData == null || statusLeadData.isEmpty) {
      EasyLoading.showError('Gagal memuat master data');
      return;
    }
    masterData.value = statusLeadData;
    for (var element in masterData) {
      listStatusLead.add(element);
    }
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
  }

  void submit() async {
    if (statusLeadId.value == 0) {
      showInputError.value = true;
      EasyLoading.showError('Semua field wajib diisi');
      return;
    }

    final res = await apiRepository.submitStatusLead(
      SubmitStatusLeadRequest(
          idStatusLead: statusLeadId.value, idLead: detail.value.idLead),
    );
    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      EasyLoading.dismiss();
      if (statusLead.value.toString().toLowerCase() == 'prospek') {
        goToDetailPages(dataProspect: res?.data?.first ?? ProspekDetailV2());
      } else {
        detail.value.statusLead = statusLead.value;
        print(detail);
        detail.refresh();
      }
    } else {
      EasyLoading.showError('Gagal disimpan');
      EasyLoading.dismiss();
    }
  }

  void goToDetailPages({ProspekDetailV2? dataProspect}) {
    Get.toNamed(Routes.ADD_PROSPEK_V2, arguments: {'data_lead': dataProspect});
  }
}
