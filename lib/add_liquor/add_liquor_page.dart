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
        title: const Text('Dodaj trunek'),
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
              height: 25,
            ),
            _buttonSave(),
          ],
        ),
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
}

class AddLiquorController extends GetxController {
  AddLiquorController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }
}
