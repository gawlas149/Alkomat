import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ios_project_multi/add_liquor/add_liquor_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../edit_liquor/edit_liquor_page.dart';
import '../model/liquor.dart';

class BreathalyserPage extends GetView<BreathalyserController> {
  const BreathalyserPage({super.key});

  static const String path = '/breathalyser_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Alkomat'),
      ),
      body: Obx(() => _body()),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          controller.startTimeChosen.value
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _timePicker(),
                    const SizedBox(width: 20),
                    _buttonClearBreathalyser(),
                  ],
                )
              : _timePicker(),
          Expanded(
            child: Stack(
              children: <Widget>[
                Expanded(child: _liquorsList()),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: controller.drunkLiquors.isEmpty
                        ? _buttonAddLiquor()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _percentageInBloodText(),
                              const SizedBox(
                                width: 10,
                              ),
                              _buttonAddLiquor(),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _liquorsList() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 12, bottom: 30),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => InkWell(
            onTap: () => {
                  Get.toNamed(EditLiquorPage.path, arguments: {
                    'name': controller.drunkLiquors[index].name,
                    'percentage':
                        controller.drunkLiquors[index].percentage.toString(),
                    'volume': controller.drunkLiquors[index].volume.toString()
                  })!
                      .then(
                    (result) => {
                      if (result != null)
                        {
                          if (result == -1)
                            {controller.drunkLiquors.removeAt(index)}
                          else
                            {
                              controller.drunkLiquors[index] = Liquor(
                                result[0],
                                double.parse(result[1]),
                                int.parse(result[2]),
                              )
                            },
                          controller.calculatePercentageInBlood(),
                          controller.updateSharedPreferencesLiquors(),
                        }
                    },
                  ),
                },
            child: _liquerRow(controller.drunkLiquors[index])),
        separatorBuilder: (BuildContext context, int index) => Container(
              height: 1,
              color: Colors.black,
            ),
        itemCount: controller.drunkLiquors.length);
  }

  Widget _timePicker() {
    return ElevatedButton(
      onPressed: () async {
        final TimeOfDay? timeOfDay = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
        );
        if (timeOfDay == null) {
          return;
        }
        controller.startTime.value = timeOfDay;

        controller.startTimeChosen.value = false; //XD
        controller.startTimeChosen.value = true;

        controller.startTimeHours =
            controller.startTime.value?.hour.toString().padLeft(2, '0');
        controller.startTimeMinutes =
            controller.startTime.value?.minute.toString().padLeft(2, '0');

        //to do jeśli jest 1 a wybierzesz 23 to znaczy że wczoraj zacząłeś pić a nie dziś
        controller.startTimeDate = DateTime.now();
        controller.updateSharedPreferencesStartTime();
        controller.calculatePercentageInBlood();
      },
      child: Obx(
        () {
          if (controller.startTimeChosen.value == true) {
            return Text(
                '${controller.startTimeHours}:${controller.startTimeMinutes}');
          } else {
            return Text('Wybierz czas rozpoczęcia libacji');
          }
        },
      ),
    );
  }

  Widget _buttonClearBreathalyser() {
    return ElevatedButton(
        child: const Text('Koniec imprezy'),
        onPressed: () => {
              controller.clearBreathalyser(),
            });
  }

  Widget _buttonAddLiquor() {
    return ElevatedButton(
      child: const Text('Dodaj trunek'),
      onPressed: () => {
        Get.toNamed(AddLiquorPage.path)!.then(
          (result) => {
            if (result != null)
              {
                controller.addLiquor(
                  result[0],
                  double.parse(result[1]),
                  int.parse(result[2]),
                )
              }
          },
        )
      },
    );
  }

  Widget _liquerRow(Liquor liquor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              liquor.name,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '${liquor.volume}ml',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '${liquor.percentage}%',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _percentageInBloodText() {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: controller.percentageInBlood.value < 0.2
              ? Colors.lightGreen
              : Colors.red,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Text('${controller.percentageInBlood.toStringAsFixed(3)}‰ we krwi'),
      ),
    );
  }
}

class BreathalyserController extends GetxController {
  BreathalyserController();

  RxList<Liquor> drunkLiquors = <Liquor>[].obs;
  RxDouble percentageInBlood = 0.0.obs;
  Rx<TimeOfDay?> startTime = TimeOfDay.now().obs;
  String? startTimeHours;
  String? startTimeMinutes;
  DateTime? startTimeDate;

  // DateTime now = new DateTime.now();
  // DateTime date = new DateTime(now.year, now.month, now.day);

  RxBool startTimeChosen = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTime();
    loadLiquors();
  }

  Future<void> addLiquor(String name, double percentage, int volume) async {
    drunkLiquors.add(
      Liquor(name, percentage, volume),
    );

    calculatePercentageInBlood();
    updateSharedPreferencesLiquors();
  }

  Future<void> loadLiquors() async {
    final prefs = await SharedPreferences.getInstance();

    final String? liquorsString = prefs.getString('drunk_liquors');

    if (liquorsString != null) {
      drunkLiquors.value = Liquor.decode(liquorsString);
      calculatePercentageInBlood();
    }
  }

  Future<void> updateSharedPreferencesLiquors() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Liquor.encode(drunkLiquors);

    await prefs.setString('drunk_liquors', encodedData);
  }

  Future<void> loadTime() async {
    final prefs = await SharedPreferences.getInstance();

    final String? minutesString = prefs.getString('start_time_minutes');
    final String? hoursString = prefs.getString('start_time_hours');
    final String? dateString = prefs.getString('start_time_date');

    if (minutesString != null) {
      startTimeMinutes = minutesString;
    }
    if (hoursString != null) {
      startTimeHours = hoursString;
    }
    if (dateString != null) {
      startTimeDate = DateTime.parse(dateString);
    }

    if (startTimeMinutes != null &&
        startTimeHours != null &&
        startTimeDate != null) {
      startTimeChosen.value = true;
    }
  }

  Future<void> updateSharedPreferencesStartTime() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('start_time_minutes', startTimeMinutes!);
    await prefs.setString('start_time_hours', startTimeHours!);
    await prefs.setString('start_time_date', startTimeDate!.toString());
  }

  Future<void> clearBreathalyser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('drunk_liquors');
    prefs.remove('start_time_minutes');
    prefs.remove('start_time_hours');
    prefs.remove('start_time_date');

    Get.back();
  }

  void calculatePercentageInBlood() {
    //suma alkoholu [g]
    double alcoholSum = 0;
    for (Liquor liquor in drunkLiquors) {
      alcoholSum += liquor.volume * liquor.percentage / 100;
    }
    alcoholSum = alcoholSum * 0.8; //bo woltaż to procenty objętościowe

    //czas który upłynął
    int minutesPassed = 0;

    DateTime? before = startTimeDate;
    DateTime now = DateTime.now();
    if (before != null) {
      before = DateTime(before.year, before.month, before.day,
          int.parse(startTimeHours!), int.parse(startTimeMinutes!));

      Duration? timeDifference = now.difference(before);
      minutesPassed = timeDifference.inMinutes;
    }

    //wspołczynnik rozkładu alkoholu 0.68 dla mężczyzn i 0.55 dla kobiet
    //to do pytać o płeć
    double r = 0.68;

    //waga [kg]
    //to do pytanie o wagę
    double weight = 90;

    // BAC by Widmark equation
    double bloodAlcoholConcentration = alcoholSum / (weight * r);

    // BAC after time by chatGPT
    percentageInBlood.value =
        bloodAlcoholConcentration - 0.02 * minutesPassed / 6;

    if (percentageInBlood.value < 0) {
      percentageInBlood.value = 0;
    }
  }
}
