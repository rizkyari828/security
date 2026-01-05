import 'package:flutter/material.dart';
import 'package:staffku/modules/home/home.dart';
import 'package:staffku/shared/shared.dart';
import 'package:get/get.dart';

import '../../shared/utils/custom_pop_scope.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return CustomPopScope(
      onWillPop: () async => false,
      child: Obx(() => _buildWidget()),
    );
  }

  Widget _buildWidget() {
    return Scaffold(
      body: Center(
        child: controller.tipeUser.value == "1"
            ? _buildContent(controller.currentTab.value)
            : _buildContentTipe2(controller.currentTab.value),
      ),
      bottomNavigationBar: _navBar(),
    );
  }

  Widget _navBar() {
    return BottomNavigationBar(
      elevation: 0,
      iconSize: 30,
      backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
      items: [
        _buildNavigationBarItem(
          "Beranda",
          MainTabs.home == controller.currentTab.value
              ? Icon(Icons.home_rounded)
              : Icon(Icons.home_outlined),
        ),
        _buildNavigationBarItem(
          "Kehadiran",
          MainTabs.discover == controller.currentTab.value
              ? Icon(Icons.alarm)
              : Icon(Icons.alarm_outlined),
        ),
        _buildNavigationBarItem(
          "Profile",
          MainTabs.me == controller.currentTab.value
              ? Icon(Icons.person_rounded)
              : Icon(Icons.person_outline_rounded),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey,
      selectedItemColor: ColorConstants.mainColor,
      currentIndex: controller.getCurrentIndex(controller.currentTab.value),
      selectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      onTap: (index) => controller.switchTab(index),
    );
  }

  Widget _buildContent(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return controller.mainTab;
      case MainTabs.discover:
        return controller.discoverTab;
      case MainTabs.me:
        return controller.meTab;
      default:
        return controller.mainTab;
    }
  }

  Widget _buildContentTipe2(MainTabs tab) {
    switch (tab) {
      case MainTabs.home:
        return controller.mainTab;
      case MainTabs.discover:
        return controller.discoverTab;
      case MainTabs.me:
        return controller.meTab;
      default:
        return controller.mainTab;
    }
  }

  BottomNavigationBarItem _buildNavigationBarItem(String label, Icon svg) {
    return BottomNavigationBarItem(
      backgroundColor: ColorConstants.lightScaffoldBackgroundColor,
      icon: svg,
      label: label,
    );
  }
}
