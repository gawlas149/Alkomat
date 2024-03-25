import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'breathalyser/breathalyser_bind.dart';
import 'breathalyser/breathalyser_page.dart';
import 'add_liquor/add_liquor_bind.dart';
import 'add_liquor/add_liquor_page.dart';
import 'edit_liquor/edit_liquor_bind.dart';
import 'edit_liquor/edit_liquor_page.dart';
import 'main_screen/main_screen_bind.dart';
import 'main_screen/main_screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IOS Projekt',

      // do wielu języków

      // translations: ApplicationTranslations(),
      // locale: Get.deviceLocale,
      // locale: const Locale('pl', 'PL'),
      // locale: const Locale('en', 'US'),
      // fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(),
      getPages: <GetPage<StatelessWidget>>[
        GetPage<MainScreenPage>(
            name: MainScreenPage.path,
            page: () => const MainScreenPage(),
            binding: MainScreenPageBind()),
        GetPage<BreathalyserPage>(
            name: BreathalyserPage.path,
            page: () => const BreathalyserPage(),
            binding: BreathalyserPageBind()),
        GetPage<AddLiquorPage>(
            name: AddLiquorPage.path,
            page: () => const AddLiquorPage(),
            binding: AddLiquerPageBind()),
        GetPage<EditLiquorPage>(
            name: EditLiquorPage.path,
            page: () => const EditLiquorPage(),
            binding: EditLiquerPageBind()),
      ],
      initialRoute: MainScreenPage.path,
      initialBinding: MainScreenPageBind(),
    );
  }
}
