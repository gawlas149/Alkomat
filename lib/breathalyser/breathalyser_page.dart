import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('breathalyser'.tr),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Obx(() => _body()),
      ),
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
                    const SizedBox(width: 10),
                    _buttonClearBreathalyser(),
                    const SizedBox(
                      width: 10,
                    ),
                    _buttonSortBreathalyser(),
                  ],
                )
              : _timePicker(),
          Expanded(child: _liquorsList()),
          controller.drunkLiquors.isEmpty
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
          initialTime: controller.startTime.value!,
        );
        if (timeOfDay == null) {
          return;
        }
        controller.startTime.value = timeOfDay;

        controller.startTimeChosen.value = false; //XD
        controller.startTimeChosen.value = true;

        controller.startTimeHours = timeOfDay.hour.toString().padLeft(2, '0');
        controller.startTimeMinutes =
            timeOfDay.minute.toString().padLeft(2, '0');

        //jeśli jest 1 a wybierzesz 23 to znaczy że wczoraj zacząłeś pić a za 22h
        if (timeOfDay.hour > TimeOfDay.now().hour) {
          controller.startTimeDate =
              DateTime.now().subtract(const Duration(days: 1));
        } else {
          controller.startTimeDate = DateTime.now();
        }

        controller.updateSharedPreferencesStartTime();
        controller.calculatePercentageInBlood();
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.black,
          elevation: 3),
      child: Obx(
        () {
          if (controller.startTimeChosen.value == true) {
            return Text(
                '${controller.startTimeHours}:${controller.startTimeMinutes}');
          } else {
            return Text('choose_time'.tr);
          }
        },
      ),
    );
  }

  Widget _buttonClearBreathalyser() {
    return ElevatedButton(
      onPressed: () => {
        showConfirmDialog(),
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.black,
          elevation: 3),
      child: Text('end'.tr),
    );
  }

  Widget _buttonAddLiquor() {
    return ElevatedButton(
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
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.black,
          elevation: 3),
      child: Text('add_liquor'.tr),
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
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              '${liquor.volume}ml',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              '${liquor.percentage}%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonSortBreathalyser() {
    return ElevatedButton(
      child: Text('sort'.tr),
      onPressed: () => {
        showSortDialog(),
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.black,
          elevation: 3),
    );
  }

  void showSortDialog() {
    final BuildContext context = Get.context!;
    final Widget cancelButton = TextButton(
      child: Text(
        'cancel'.tr,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final AlertDialog alert = AlertDialog(
      title: Text(
        'sort'.tr,
        textAlign: TextAlign.center,
      ),
      titlePadding: const EdgeInsets.only(top: 18),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => {
              controller.drunkLiquors.sort((a, b) => a.name.compareTo(b.name)),
              Navigator.of(context).pop(),
              controller.updateSharedPreferencesLiquors(),
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                elevation: 3),
            child: Text(
              'sort_az'.tr,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              controller.drunkLiquors.sort((a, b) => b.name.compareTo(a.name)),
              Navigator.of(context).pop(),
              controller.updateSharedPreferencesLiquors(),
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                elevation: 3),
            child: Text(
              'sort_za'.tr,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              controller.drunkLiquors
                  .sort((a, b) => a.volume.compareTo(b.volume)),
              Navigator.of(context).pop(),
              controller.updateSharedPreferencesLiquors(),
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                elevation: 3),
            child: Text(
              'sort_ml+'.tr,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              controller.drunkLiquors
                  .sort((a, b) => b.volume.compareTo(a.volume)),
              Navigator.of(context).pop(),
              controller.updateSharedPreferencesLiquors(),
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                elevation: 3),
            child: Text(
              'sort_ml-'.tr,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              controller.drunkLiquors
                  .sort((a, b) => a.percentage.compareTo(b.percentage)),
              Navigator.of(context).pop(),
              controller.updateSharedPreferencesLiquors(),
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                elevation: 3),
            child: Text(
              'sort_perc+'.tr,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              controller.drunkLiquors
                  .sort((a, b) => b.percentage.compareTo(a.percentage)),
              Navigator.of(context).pop(),
              controller.updateSharedPreferencesLiquors(),
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.black,
                elevation: 3),
            child: Text(
              'sort_perc-'.tr,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      contentPadding:
          const EdgeInsets.only(top: 6, bottom: 18, left: 6, right: 6),
      actions: <Widget>[
        cancelButton,
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _percentageInBloodText() {
    if (controller.userLimit != null) {
      return InkWell(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: controller.percentageInBlood.value < controller.userLimit!
                ? Colors.lightGreen
                : Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'percentage_in_blood'.trParams(<String, String>{
                'percentage': controller.percentageInBlood.toStringAsFixed(3)
              }),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
        onTap: () => {
          showInfoDialog(),
        },
      );
    } else {
      return InkWell(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: controller.percentageInBlood.value < 0.2
                ? Colors.lightGreen
                : Colors.red,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'percentage_in_blood'.trParams(<String, String>{
                'percentage': controller.percentageInBlood.toStringAsFixed(3)
              }),
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
        onTap: () => {
          showInfoDialog(),
        },
      );
    }
  }

  void showConfirmDialog() {
    final BuildContext context = Get.context!;
    final Widget cancelButton = TextButton(
      child: Text(
        'end_no'.tr,
        style: TextStyle(fontSize: 18, color: Colors.green),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    final Widget continueButton = TextButton(
      child: Text(
        'end_yes'.tr,
        style: TextStyle(fontSize: 18, color: Colors.green),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        controller.clearBreathalyser();
      },
    );

    final AlertDialog alert = AlertDialog(
      title: Text(
        'end'.tr,
        textAlign: TextAlign.center,
      ),
      titlePadding: const EdgeInsets.only(top: 18),
      content: Text(
        'end_question'.tr,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      contentPadding:
          const EdgeInsets.only(top: 6, bottom: 18, left: 6, right: 6),
      actions: <Widget>[
        cancelButton,
        continueButton,
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showInfoDialog() {
    final BuildContext context = Get.context!;
    final Widget okeyButton = TextButton(
      child: Text(
        'okey'.tr,
        style: TextStyle(fontSize: 18, color: Colors.green),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final AlertDialog alert = AlertDialog(
      title: Text(
        'reaction'.tr,
        textAlign: TextAlign.center,
      ),
      titlePadding: const EdgeInsets.only(top: 18),
      content: Text(
        _infoText(),
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 18, left: 10, right: 10),
      actions: <Widget>[
        okeyButton,
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18))),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String _infoText() {
    double percentageInBlood = controller.percentageInBlood.value;
    if (percentageInBlood == 0) {
      return 'drunk1'.tr;
    }
    if (percentageInBlood < 0.2) {
      return 'drunk2'.tr;
    }
    if (percentageInBlood < 0.5) {
      return 'drunk3'.tr;
    }
    if (percentageInBlood < 0.7) {
      return 'drunk4'.tr;
    }
    if (percentageInBlood < 2) {
      return 'drunk5'.tr;
    }
    if (percentageInBlood < 3) {
      return 'drunk6'.tr;
    }
    if (percentageInBlood < 4) {
      return 'drunk7'.tr;
    }
    if (percentageInBlood < 5) {
      return 'drunk8'.tr;
    }
    return 'drunk9'.tr;
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
  RxBool startTimeChosen = false.obs;

  double? userWeight;
  double? userLimit;
  String? userGender;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
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

    DateTime? before = startTimeDate;
    if (before != null) {
      before = DateTime(before.year, before.month, before.day,
          int.parse(startTimeHours!), int.parse(startTimeMinutes!));
    }

    if (startTimeMinutes != null &&
        startTimeHours != null &&
        startTimeDate != null) {
      startTime.value = TimeOfDay(
        hour: int.parse(
          startTimeHours.toString(),
        ),
        minute: int.parse(
          startTimeMinutes.toString(),
        ),
      );
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
    double r = 0.68;
    if (userGender == 'female') {
      r = 0.55;
    }

    double bloodAlcoholConcentration = 0;
    // BAC by Widmark equation
    if (userWeight != null) {
      bloodAlcoholConcentration = alcoholSum / (userWeight! * r);
    } else {
      bloodAlcoholConcentration = alcoholSum / (90 * r);
    }

    // BAC after time by chatGPT
    percentageInBlood.value =
        bloodAlcoholConcentration - 0.02 * minutesPassed / 6;

    if (percentageInBlood.value < 0) {
      percentageInBlood.value = 0;
    } else if (percentageInBlood.value > 1000) {
      percentageInBlood.value = 1000;
    }
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    userWeight = double.parse(prefs.getString('user_weight').toString());
    userLimit = double.parse(prefs.getString('user_limit').toString());
    userGender = prefs.getString('user_gender');
  }
}
