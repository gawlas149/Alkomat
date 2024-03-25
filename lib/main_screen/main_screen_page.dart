import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ios_project_multi/breathalyser/breathalyser_page.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Jakaś fajna treść, logo czy coś \nchyba by tu było pytanie o wagę i próg kiedy za dużo promili',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Get.toNamed(BreathalyserPage.path)},
        child: const Icon(Icons.blender),
      ),
    );
  }
}

class MainScreenController extends GetxController {
  MainScreenController(this.inputController);

  final TextEditingController inputController;

  @override
  void onInit() {
    super.onInit();
  }
}
