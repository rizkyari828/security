import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:staffku/api/api_repository.dart';
import 'package:staffku/models/request/store/update_qty_request.dart';
import 'package:staffku/models/request/user_id_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:staffku/models/response/store/list_items.dart';
import 'package:staffku/modules/home/base_controller.dart';
import 'package:staffku/shared/utils/common_widget.dart';
import 'package:staffku/shared/widgets/button.dart';
import 'package:staffku/shared/widgets/input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreController extends BaseController {
  StoreController({required ApiRepository apiRepository})
    : super(apiRepository: apiRepository);

  final TextEditingController jumlah = TextEditingController();
  final TextEditingController note = TextEditingController();
  final argm = Get.arguments;
  RxString groupName = "".obs;
  RxString groupId = "".obs;
  RxString placement = "".obs;
  RxString nameItem = "".obs;
  RxString idType = "".obs;
  RxString idUser = "".obs;
  RxString token = "".obs;

  var listProduct = <Items>[].obs;
  RxInt page = 1.obs;
  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );
  final box = GetStorage();

  void getItems(page) async {
    final res = await apiRepository.listItems(
      page: page,
      data: UserIdRequest(id: idUser.value),
    );
    listProduct.addAll(res?.data ?? []);
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listProduct.clear();
    page.value = 1;
    getItems(page.value);
    refreshController.refreshCompleted();
  }

  void onLoading() async {
    // page.value = page.value + 1;

    // // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // getItems(page.value);
    // refreshController.loadComplete();
  }

  void submitData(String idBarang, String qty) async {
    if (!isConnectedToInternet.value) {
      box.write(
        'barang',
        QtyUpdateRequest(
          userId: idUser.value,
          barangId: idBarang,
          tokoId: argm,
          qty: qty,
        ),
      );

      print(box.read('barang'));
    }

    final res = await apiRepository.decreaseQtyItems(
      QtyUpdateRequest(
        userId: idUser.value,
        barangId: idBarang,
        tokoId: argm,
        qty: qty,
      ),
    );

    if (res?.error == false) {
      EasyLoading.showSuccess('Berhasil disimpan');
      EasyLoading.dismiss();
      Get.back();
    } else {
      // Get.back();
      // Get.defaultDialog(
      //     title: "DATA GAGAL DIKIRIM",
      //     content: CommonWidget.subtitleText(
      //         text: "Gagal dikirim namun tersimpan di local memory",
      //         textAlign: TextAlign.center),
      //     textConfirm: 'OK',
      //     textCancel: 'CANCLE',
      //     onConfirm: () {
      //       Get.back();
      //       // Get.toNamed(Routes.STORE);
      //     },
      //     onCancel: () {
      //       Get.back();
      //     });
      EasyLoading.showError('Gagal dikirim namun tersimpan di local memory');
      EasyLoading.dismiss();
      Get.back();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    getItems(page.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  loadUsers() async {
    var prefs = Get.find<SharedPreferences>();
    groupName.value = prefs.getString('groupName') ?? "";
    groupId.value = prefs.getString('groupId') ?? "";
    placement.value = prefs.getString('placement') ?? "";
    token.value = prefs.getString('token') ?? "";
    idUser.value = prefs.getString('userId') ?? "";
  }

  void inputDataSheet(BuildContext context, String idBarang, String itemName) {
    Get.bottomSheet(
      Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  CommonWidget.rowHeight(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonWidget.subtitleText(text: 'Update Stock '),
                          CommonWidget.minHeadText(text: itemName),
                        ],
                      ),
                    ),
                  ),
                  CommonWidget.rowHeight(),
                  InputInputField(
                    keyboardType: TextInputType.number,
                    controller: jumlah,
                    labelText: "Jumlah",
                  ),
                  InputInputField(
                    keyboardType: TextInputType.text,
                    controller: note,
                    labelText: "Catatan (Optional)",
                  ),
                  CommonWidget.rowHeight(),
                  CustomButton(
                    buttonText: 'SIMPAN',
                    width: MediaQuery.of(context).size.width,
                    onPressed: () {
                      submitData(idBarang, jumlah.text);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      elevation: 20.0,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
