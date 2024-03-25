import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_screen_page.dart';

class MainScreenPageBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TextEditingController>(() => TextEditingController(),
        fenix: true);
    Get.lazyPut<MainScreenController>(() => MainScreenController(Get.find()),
        fenix: true);
  }
}
