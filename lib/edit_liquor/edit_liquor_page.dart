import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditLiquorPage extends GetView<EditLiquorController> {
  const EditLiquorPage({super.key});

  static const String path = '/edit_liquor_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('edit_liquor'.tr),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Column(
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
                floatingLabelStyle: const TextStyle(color: Colors.green),
                focusedBorder: const UnderlineInputBorder(
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
                floatingLabelStyle: const TextStyle(color: Colors.green),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('liquor_volume'.tr),
              ),
              onChanged: (String text) {
                controller.checkVolume(text);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            _rowAddVolume(),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                _buttonDelete(),
                const Spacer(),
                Obx(
                  () => (controller.voltageCorrect.value &&
                          controller.volumeCorrect.value)
                      ? _buttonSaveEnabled()
                      : _buttonSaveDisabled(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _rowAddVolume() {
    return Row(
      children: [
        _buttonAddVolume(30),
        const SizedBox(
          width: 15,
        ),
        _buttonAddVolume(100),
        const SizedBox(
          width: 15,
        ),
        _buttonAddVolume(500)
      ],
    );
  }

  Widget _buttonAddVolume(int volume) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => {
          controller.volumeController.text =
              (int.parse(controller.volumeController.text) + volume).toString()
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.black,
            elevation: 3),
        child: Text('+ $volume'),
      ),
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

  Widget _buttonDelete() {
    return ElevatedButton(
      onPressed: () => {Get.back(result: -1)},
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.black,
          elevation: 3),
      child: Text('liquor_delete'.tr),
    );
  }
}

class EditLiquorController extends GetxController {
  EditLiquorController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

  RxBool voltageCorrect = true.obs;
  RxBool volumeCorrect = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    nameController.text = Get.arguments['name'];
    percentageController.text = Get.arguments['percentage'];
    volumeController.text = Get.arguments['volume'];
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
