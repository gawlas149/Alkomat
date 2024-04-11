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
        title: const Text('Strona główna'),
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
              'Celem aplikacji jest mierzenie stężenia alkoholu we krwi w trakcie imprezy\n\nKontroluj jak bardzo jesteś pijany poprzez systematyczne aktualizowanie wypitych trunków\n\n',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              'Aby aplikacja działała skuteczniej potrzebujemy paru informacji o Tobie:',
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              maxLength: 4,
              keyboardType: TextInputType.number,
              controller: controller.weightController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('Twoja waga [kg]'),
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
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('Twój limit alkoholu [‰]'),
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
          Text('Twoja płeć:'),
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
                Text('Mężczyzna'),
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
                Text('Kobieta'),
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
