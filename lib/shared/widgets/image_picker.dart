import 'dart:io';
import 'package:staffku/models/response/Lead/list_lead_respone.dart';
import 'package:staffku/modules/home/home_controller.dart';
import 'package:staffku/shared/shared.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker {
  static Widget previewImages(HomeController controller) {
    final Text? retrieveError = _getRetrieveErrorWidget(controller);
    if (retrieveError != null) {
      return retrieveError;
    }
    if (controller.imageFileList.isNotEmpty) {
      return Semantics(
        label: 'image_picker_example_picked_image',
        child: kIsWeb
            ? Image.network(controller.imageFileList.first.path)
            : Image.file(File(controller.imageFileList.first.path)),
      );
    } else if (controller.pickImageError != null) {
      return CommonWidget.bodyText(text: "Loading", color: Colors.grey);
    } else {
      return CommonWidget.bodyText(
        text: "Anda belum memilih foto",
        color: Colors.grey,
      );
    }
  }

  static Widget previewGridImages(controller) {
    final Text? retrieveError = _getRetrieveErrorWidget(controller);
    if (retrieveError != null) {
      return retrieveError;
    }
    if (controller.imageFileList != null &&
        controller.imageFileList.isNotEmpty) {
      return Semantics(
        child: GridView.count(
          key: UniqueKey(),
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // <--- ini penting!
          children: List.generate(controller.imageFileList.length, (index) {
            final item = controller.imageFileList[index];
            // Cek apakah item punya properti 'img' (dari API)
            if (item is Foto && (item.img == null || item.img!.isEmpty)) {
              return const Icon(Icons.broken_image);
            } else if (item is Foto && item.img!.startsWith('http')) {
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: Image.network(item.img!),
              );
            } else if (item.path != null) {
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(item.path)
                    : Image.file(File(item.path)),
              );
            } else {
              return const Icon(Icons.broken_image);
            }
          }),
        ),
        label: 'image_picker_example_picked_images',
      );
    } else if (controller.pickImageError != null) {
      return Text(
        'Pick image error: ${controller.pickImageError}',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text('', textAlign: TextAlign.center);
    }
  }

  static Widget singlePreviewGridImages(List imageFileList, {String? label}) {
    if (imageFileList.isNotEmpty) {
      return Semantics(
        child: GridView.count(
          key: UniqueKey(),
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(imageFileList.length, (index) {
            final item = imageFileList[index];
            if (item is Foto && (item.img == null || item.img!.isEmpty)) {
              return const Icon(Icons.broken_image);
            } else if (item is Foto && item.img!.startsWith('http')) {
              return Semantics(
                label: label ?? 'image_picker_example_picked_image',
                child: Image.network(item.img!),
              );
            } else if (item.path != null) {
              return Semantics(
                label: label ?? 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(item.path)
                    : Image.file(File(item.path)),
              );
            } else {
              return const Icon(Icons.broken_image);
            }
          }),
        ),
        label: label ?? 'image_picker_example_picked_images',
      );
    } else {
      return const Text('', textAlign: TextAlign.center);
    }
  }

  static Text? _getRetrieveErrorWidget(controller) {
    if (controller.retrieveDataError != null) {
      final Text result = Text(controller.retrieveDataError?.value ?? "");
      controller.retrieveDataError = null;
      return result;
    }
    return null;
  }

  static Widget cardPickCamera(context, controller) {
    final sw = SizeConfig().screenWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0),
        CommonWidget.bodyText(text: "Dokumen"),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Obx(() => CustomImagePicker.previewGridImages(controller)),
        ),
        InkWell(
          onTap: () {
            controller.onImageButtonPressed(
              ImageSource.camera,
              context: context,
            );
          },
          child: DottedBorder(
            options: RectDottedBorderOptions(
              color: Colors.grey,
              dashPattern: [8, 4],
              strokeWidth: 1,
            ),
            child: Container(
              height: 50,
              width: sw,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.grey, size: 30),
                  SizedBox(width: 10.0),
                  CommonWidget.bodyText(
                    text: "Ambil Photo",
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
        // SizedBox(height: 10.0),
        // CommonWidget.captionText(
        //     text: "Lampiran yang diizinkan PDF, PNG, JPG, JPEG"),
        SizedBox(height: 20.0),
      ],
    );
  }
}

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network('https://picsum.photos/250?image=9'),
          ),
        ),
      ),
    );
  }
}
