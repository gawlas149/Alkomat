import 'package:get/get.dart';

import 'main_screen_page.dart';

class MainScreenPageBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainScreenController>(() => MainScreenController(),
        fenix: true);
  }
}
