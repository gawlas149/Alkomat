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
                _buttonSave(),
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
      ),
    );
  }

  Widget _buttonSave() {
    return ElevatedButton(
      child: const Text('Zapisz trunek'),
      onPressed: () => {
        Get.back(result: [
          controller.nameController.text,
          controller.percentageController.text,
          controller.volumeController.text
        ])
      },
    );
  }

  Widget _buttonDelete() {
    return ElevatedButton(
      child: const Text('Usuń trunek'),
      onPressed: () => {Get.back(result: -1)},
    );
  }
}

class EditLiquorController extends GetxController {
  EditLiquorController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

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
}
