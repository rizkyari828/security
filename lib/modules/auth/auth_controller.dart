import 'package:flutter/material.dart';
import 'package:staffku/api/api.dart';
import 'package:staffku/models/models.dart';
import 'package:staffku/routes/app_pages.dart';
import 'package:staffku/shared/shared.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final ApiRepository apiRepository;
  AuthController({required this.apiRepository});

  // final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  bool registerTermsChecked = false;

  final formKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  RxBool isObscured = true.obs;
  // bool get isObscured => _isObscured;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void login(BuildContext context) async {
    AppFocus.unfocus(context);
    if (formKey.currentState!.validate()) {
      final res = await apiRepository.login(
        loginEmailController.text,
        loginPasswordController.text,
        LoginRequest(
          username: loginEmailController.text,
          password: loginPasswordController.text,
          kunci: ApiConstants.loginKunci,
        ),
      );

      print(res);

      // print("Bearer " + res!.token.toString());

      final prefs = Get.find<SharedPreferences>();
      prefs.clear();
      if (res?.error == false) {
        final hasUser = res?.data?.isNotEmpty == true;
        final firstUser = hasUser ? res!.data!.first : null;
        final hasToken = (firstUser?.token?.isNotEmpty ?? false);

        if (hasToken) {
          prefs.setString(StorageConstants.token, firstUser?.token ?? '');
          prefs.setString(StorageConstants.name, firstUser?.nama ?? '');
          prefs.setString(
            StorageConstants.userId,
            firstUser?.userId.toString() ?? "",
          );
          prefs.setString(
            StorageConstants.idPegawai,
            firstUser?.idPegawai.toString() ?? "",
          );
          prefs.setString(
            StorageConstants.username,
            firstUser?.username.toString() ?? "",
          );
          prefs.setString(StorageConstants.profilePhoto, firstUser?.foto ?? "");
          prefs.setString(
            StorageConstants.groupId,
            firstUser?.stsUser.toString() ?? "",
          );
          prefs.setString(
            StorageConstants.tipe,
            firstUser?.tipe.toString() ?? "",
          );
          final menus = firstUser?.menus;

          if (menus != null) {
            prefs.setBool('menu_kunjungan', menus.kunjungan ?? false);
            prefs.setBool('menu_leads', menus.leads ?? false);
            prefs.setBool('menu_prospek', menus.prospek ?? false);
            prefs.setBool('menu_agent', menus.agent ?? false);
            prefs.setBool('menu_benefit', menus.benefit ?? false);
            prefs.setBool('menu_lembur', menus.lembur ?? false);
            prefs.setBool('menu_cuti', menus.cuti ?? false);
            prefs.setBool('menu_kuisioner', menus.kuisioner ?? false);
          }

          Get.find<FcmTokenService>().syncToken();
          Get.offAllNamed(Routes.HOME);
        }
      }
    }
  }

  void submitToken(token) async {
    // final res = await apiRepository
    //     .updateFcmProfile(UpdateFcmProfileRequest(fcmToken: token));
    // if (res?.error == false) {
    //   print('Token updated');
    // } else {
    //   print('Token update failed');
    // }
    // listType.addAll(res?.data ?? []);
  }

  void register(BuildContext context) async {
    AppFocus.unfocus(context);
    // if (registerFormKey.currentState!.validate()) {
    //   if (!registerTermsChecked) {
    //     CommonWidget.toast('Please check the terms first.');
    //     return;
    //   }

    //   final res = await apiRepository.register(
    //     RegisterRequest(
    //       email: registerEmailController.text,
    //       password: registerPasswordController.text,
    //     ),
    //   );

    //   final prefs = Get.find<SharedPreferences>();
    //   if (res!.token.isNotEmpty) {
    //     prefs.setString(StorageConstants.token, res.token);
    //     print('Go to Home screen');
    //   }
    // }
  }

  void toggleVisibility() => isObscured.value == true
      ? isObscured.value = false
      : isObscured.value = true;

  @override
  void onClose() {
    super.onClose();

    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();

    loginEmailController.dispose();
    loginPasswordController.dispose();
  }
}
