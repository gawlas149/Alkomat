import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios_project_multi/breathalyser/breathalyser_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenPage extends GetView<MainScreenController> {
  const MainScreenPage({super.key});

  static const String path = '/main_screen_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('main_screen'.tr),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.language,
              size: 36,
            ),
            onPressed: () {
              if (Get.locale.toString() == 'en_US') {
                Get.updateLocale(const Locale('pl', 'PL'));
              } else {
                Get.updateLocale(const Locale('en', 'US'));
              }
            },
          ),
        ],
      ),
      body: _body(),
      floatingActionButton: Obx(
        () => (controller.weightCorrect.value && controller.limitCorrect.value)
            ? _floatingActionButtonEnabled()
            : _floatingActionButtonDisabled(),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text(
              'main_screen_info1'.tr,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              'main_screen_info2'.tr,
              style: const TextStyle(fontSize: 16),
            ),
            TextFormField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              controller: controller.weightController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(color: Colors.green),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('your_weight'.tr),
              ),
              onChanged: (String text) {
                controller.checkWeight(text);
              },
            ),
            TextFormField(
              maxLength: 5,
              keyboardType: TextInputType.number,
              controller: controller.limitController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(color: Colors.green),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('your_limit'.tr),
              ),
              onChanged: (String text) {
                controller.checkLimit(text);
              },
            ),
            _genderSelector(),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButtonEnabled() {
    return FloatingActionButton(
      backgroundColor: const Color.fromRGBO(139, 195, 74, 1),
      onPressed: () => {controller.moveToBreathalyser()},
      child: const Icon(Icons.blender),
    );
  }

  FloatingActionButton _floatingActionButtonDisabled() {
    return const FloatingActionButton(
      backgroundColor: Color.fromARGB(94, 148, 193, 34),
      onPressed: null,
      child: Icon(Icons.blender),
    );
  }

  Widget _genderSelector() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text('your_gender'.tr),
          InkWell(
            child: Row(
              children: [
                Radio(
                  activeColor: Colors.lightGreen,
                  value: 'male',
                  groupValue: controller.selectedGender!.value,
                  onChanged: (_) {
                    controller.selectedGender!.value = 'male';
                  },
                ),
                Text('male'.tr),
              ],
            ),
            onTap: () => {controller.selectedGender!.value = 'male'},
          ),
          InkWell(
            child: Row(
              children: [
                Radio(
                  activeColor: Colors.lightGreen,
                  value: 'female',
                  groupValue: controller.selectedGender!.value,
                  onChanged: (_) {
                    controller.selectedGender!.value = 'female';
                  },
                ),
                Text('female'.tr),
              ],
            ),
            onTap: () => {controller.selectedGender!.value = 'female'},
          ),
        ],
      ),
    );
  }
}

class MainScreenController extends GetxController {
  MainScreenController();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController limitController = TextEditingController();
  RxString? selectedGender = 'male'.obs;

  RxBool weightCorrect = true.obs;
  RxBool limitCorrect = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    weightController.text = prefs.getString('user_weight') ?? '100';
    limitController.text = prefs.getString('user_limit') ?? '0.2';
    selectedGender!.value = prefs.getString('user_gender') ?? 'male';
  }

  Future<void> moveToBreathalyser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_weight', weightController.text);
    await prefs.setString('user_limit', limitController.text);
    await prefs.setString('user_gender', selectedGender!.value);

    Get.toNamed(BreathalyserPage.path);
  }

  void checkWeight(String newString) {
    num? newNumber = num.tryParse(newString);
    if (newNumber == null) {
      weightCorrect.value = false;
    } else {
      weightCorrect.value =
          isNumeric(newString) && num.tryParse(newString)! > 0;
    }
  }

  void checkLimit(String newString) {
    num? newNumber = num.tryParse(newString);
    if (newNumber == null) {
      limitCorrect.value = false;
    } else {
      limitCorrect.value = isNumeric(newString) &&
          num.tryParse(newString)! > 0 &&
          num.tryParse(newString)! < 1000;
    }
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
