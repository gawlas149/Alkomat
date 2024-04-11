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
        title: const Text('Edytuj trunek'),
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
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('Nazwa trunku'),
              ),
            ),
            TextFormField(
              maxLength: 5,
              keyboardType: TextInputType.number,
              controller: controller.percentageController,
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('Woltaż trunku [%]'),
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
              decoration: const InputDecoration(
                floatingLabelStyle: TextStyle(color: Colors.green),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                label: Text('Objętość trunku [ml]'),
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
        child: Text('+ $volume'),
        onPressed: () => {
          controller.volumeController.text =
              (int.parse(controller.volumeController.text) + volume).toString()
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.black,
            elevation: 3),
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
      child: Text('Zapisz trunek'),
    );
  }

  Widget _buttonSaveDisabled() {
    return const ElevatedButton(
      onPressed: null,
      child: Text('Zapisz trunek'),
    );
  }

  Widget _buttonDelete() {
    return ElevatedButton(
      child: const Text('Usuń trunek'),
      onPressed: () => {Get.back(result: -1)},
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.black,
          elevation: 3),
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
