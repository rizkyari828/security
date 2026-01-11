import 'package:get/get.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/claim/detail_claim_request.dart';
import 'package:staffku/models/response/claim/show_claim_response.dart';
import 'package:staffku/shared/utils/common_widget.dart';

class ClaimDetailController extends GetxController {
  final ApiRepository apiRepository;
  ClaimDetailController({required this.apiRepository});

  final argm = Get.arguments;
  final detail = Rxn<ShowClaimItem>();
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchDetail();
  }

  Future<void> onRefresh() async {
    await fetchDetail();
  }

  Future<void> fetchDetail() async {
    final id = argm?.toString().trim() ?? '';
    if (id.isEmpty) return;

    isLoading.value = true;
    try {
      final res = await apiRepository.showClaim(ShowClaimRequest(id: id));
      final data = res?.data;
      if (data == null || data.isEmpty) {
        CommonWidget.errorSnackBar('Gagal memuat detail claim');
        return;
      }
      detail.value = data.first;
    } finally {
      isLoading.value = false;
    }
  }
}
