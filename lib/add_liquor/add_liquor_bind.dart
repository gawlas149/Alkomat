import 'package:get/get.dart';

import 'add_liquor_page.dart';

class AddLiquerPageBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLiquorController>(() => AddLiquorController(), fenix: true);
  }
}
