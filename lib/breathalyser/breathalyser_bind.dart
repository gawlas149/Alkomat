import 'package:get/get.dart';

import 'breathalyser_page.dart';

class BreathalyserPageBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreathalyserController>(() => BreathalyserController(),
        fenix: true);
  }
}
