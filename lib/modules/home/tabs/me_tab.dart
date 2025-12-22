import 'package:cached_network_image/cached_network_image.dart';
import 'package:sales/shared/widgets/button.dart';
import 'package:sales/shared/widgets/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:sales/modules/home/home.dart';
import 'package:sales/shared/shared.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MeTab extends GetView<HomeController> {
  final sw = SizeConfig().screenWidth;
  final sh = SizeConfig().screenHeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: ColorConstants.black //change your color here
                ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: ColorConstants.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0,
        backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            width: 55,
            margin: EdgeInsets.only(
              right: 10.0,
            ),
            padding: EdgeInsets.all(10),
            child: InkWell(
                onTap: controller.goToNotificationPages,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.mainColor,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        width: 2.0, color: ColorConstants.borderColor),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: CommonWidget.setOpacity(Colors.black, 0.3),
                    //     blurRadius: 15.0,
                    //     spreadRadius: 1.0,
                    //   ),
                    // ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.notifications,
                        color: ColorConstants.white, size: 20),
                  ),
                )),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                changePhoto(context, controller);
              },
              child: Obx(() => Container(
                    height: SizeConfig().screenWidth * 0.3,
                    width: SizeConfig().screenWidth * 0.3,
                    child: _buildAvatar(),
                  )),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Align(alignment: Alignment.centerLeft, child: _buildListData()),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: sw * .1, right: sw * .02),
        child: CustomButton(
            borderColor: ColorConstants.mainColor,
            buttonColor: Colors.white,
            buttonTextColor: ColorConstants.mainColor,
            buttonText: 'LOGOUT',
            width: sw,
            onPressed: controller.signout),
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipOval(
      // borderRadius: BorderRadius.circular(10.0),
      child: controller.profilePhoto.value.isNotEmpty
          ? CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: controller.profilePhoto.value,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: ColorConstants.mainColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: ColorConstants.mainColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: ColorConstants.mainColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
    );
  }

  Widget _buildListData() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20.0),
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listCard(Icons.person, 'Username', controller.username.value),
              SizedBox(height: 20),
              listCard(Icons.text_fields, 'Name', controller.name.value),
              SizedBox(height: 20),
              listCard(Icons.verified_user_rounded, 'ID',
                  controller.idPegawai.value),
              SizedBox(height: 20),
              // listCard(
              //     Icons.business_center, 'Tipe', controller.tipeUser.value),
              // SizedBox(height: 20),
              listCard(getRoleIcon(controller.groupId.value), 'Role',
                  CommonWidget.getRoleLabel(controller.groupId.value)),
              SizedBox(height: 20),
            ],
          )),
    );
  }

  IconData getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case '4':
        return Icons.admin_panel_settings;
      case '3':
        return Icons.supervisor_account;
      case '2':
        return Icons.manage_accounts;
      case '1':
        return Icons.person_pin;
      default:
        return Icons.person_outline;
    }
  }

  Widget listCard(IconData icon, String label, String value) {
    final sw = SizeConfig().screenWidth;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(width: 2.0, color: ColorConstants.borderColor),
        // boxShadow: [
        //   BoxShadow(
        //     color: CommonWidget.setOpacity(Colors.black, 0.3),
        //     blurRadius: 20.0,
        //     spreadRadius: 4.0,
        //     offset: Offset(
        //       -10.0,
        //       10.0,
        //     ),
        //   ),
        // ],
      ),
      width: SizeConfig().screenWidth,
      height: sw * .13,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: sw * .05,
          ),
          Icon(
            icon,
            color: ColorConstants.mainColor,
            size: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonWidget.captionText(
                text: label,
              ),
              CommonWidget.bodyText(
                text: value,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void changePhoto(context, controller) {
    Get.defaultDialog(
      title: "Ubah Foto Profil",
      content: Obx(() => Column(
            children: [
              Container(
                height: 100,
                width: 100,
                child: CustomImagePicker.previewImages(controller),
              ),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      child: Container(
                        decoration: new BoxDecoration(
                          color: ColorConstants.mainColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2.0, color: ColorConstants.borderColor),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: CommonWidget.setOpacity(Colors.black, 0.3),
                          //     blurRadius: 20.0,
                          //     spreadRadius: 4.0,
                          //     offset: Offset(
                          //       -10.0,
                          //       10.0,
                          //     ),
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        controller.onImageButtonPressed(ImageSource.camera,
                            context: context);
                      },
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      child: Container(
                        decoration: new BoxDecoration(
                          color: ColorConstants.mainColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2.0, color: ColorConstants.borderColor),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: CommonWidget.setOpacity(Colors.black, 0.3),
                          //     blurRadius: 20.0,
                          //     spreadRadius: 4.0,
                          //     offset: Offset(
                          //       -10.0,
                          //       10.0,
                          //     ),
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        controller.onImageButtonPressed(ImageSource.gallery,
                            context: context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          )),
      textConfirm: 'Submit',
      textCancel: 'Batal',
      onCancel: () {
        Get.back();
      },
      onConfirm: () {
        controller.submitPhotoProfile();
      },
    );
  }
}
