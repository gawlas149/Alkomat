import 'package:get/get.dart';

import 'edit_liquor_page.dart';

class EditLiquerPageBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditLiquorController>(() => EditLiquorController(),
        fenix: true);
  }
}
