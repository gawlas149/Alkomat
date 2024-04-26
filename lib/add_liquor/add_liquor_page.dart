import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLiquorPage extends GetView<AddLiquorController> {
  const AddLiquorPage({super.key});

  static const String path = '/add_liquor_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('add_liquor'.tr),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
          child: Obx(
        () => Column(
          children: [
            TextFormField(
              maxLength: 15,
              controller: controller.nameController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(color: Colors.green),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('liquor_name'.tr),
              ),
            ),
            TextFormField(
              maxLength: 5,
              keyboardType: TextInputType.number,
              controller: controller.percentageController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('liquor_voltage'.tr),
              ),
              onChanged: (String text) {
                controller.checkVoltage(text);
              },
            ),
            TextFormField(
              maxLength: 5,
              keyboardType: TextInputType.number,
              controller: controller.volumeController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('liquor_volume'.tr),
              ),
              onChanged: (String text) {
                controller.checkVolume(text);
              },
            ),
            const SizedBox(
              height: 25,
            ),
            (controller.voltageCorrect.value && controller.volumeCorrect.value)
                ? _buttonSaveEnabled()
                : _buttonSaveDisabled(),
          ],
        ),
      )),
    );
  }

  Widget _buttonSaveEnabled() {
    return ElevatedButton(
      onPressed: () => {
        Get.back(result: [
          controller.nameController.text,
          controller.percentageController.text,
          controller.volumeController.text
        ])
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.black,
          elevation: 3),
      child: Text('liquor_save'.tr),
    );
  }

  Widget _buttonSaveDisabled() {
    return ElevatedButton(
      onPressed: null,
      child: Text('liquor_save'.tr),
    );
  }
}

class AddLiquorController extends GetxController {
  AddLiquorController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

  RxBool voltageCorrect = false.obs;
  RxBool volumeCorrect = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void checkVoltage(String newString) {
    num? newNumber = num.tryParse(newString);
    if (newNumber == null) {
      voltageCorrect.value = false;
    } else {
      voltageCorrect.value = isNumeric(newString) &&
          num.tryParse(newString)! > 0 &&
          num.tryParse(newString)! <= 100;
    }
  }

  void checkVolume(String newString) {
    num? newNumber = num.tryParse(newString);
    if (newNumber == null) {
      volumeCorrect.value = false;
    } else {
      volumeCorrect.value =
          isNumeric(newString) && num.tryParse(newString)! > 0;
    }
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
