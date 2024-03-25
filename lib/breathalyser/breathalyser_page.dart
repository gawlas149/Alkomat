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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 12, bottom: 30),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) => InkWell(
                    onTap: () => {
                          Get.toNamed(EditLiquorPage.path, arguments: {
                            'name': controller.drunkLiquors[index].name,
                            'percentage': controller
                                .drunkLiquors[index].percentage
                                .toString(),
                            'volume':
                                controller.drunkLiquors[index].volume.toString()
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
                                  controller.updateSharedPreferences(),
                                }
                            },
                          ),
                        },
                    child: _liquerRow(controller.drunkLiquors[index])),
                separatorBuilder: (BuildContext context, int index) =>
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                itemCount: controller.drunkLiquors.length),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: controller.drunkLiquors.isEmpty
                  ? _button()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _percentageInBloodText(),
                        const SizedBox(
                          width: 10,
                        ),
                        _button(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
      child: const Text('Dodaj trunek'),
      onPressed: () => {
        // controller.drunkLiquors.add(
        //   Liquor('Wódeczka', 40.0, 300),
        // ),

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
          color: controller.percentageInBlood.value < 0.5
              ? Colors.lightGreen
              : Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('${controller.percentageInBlood}‰ we krwi'),
      ),
    );
  }
}

class BreathalyserController extends GetxController {
  BreathalyserController();

  RxList<Liquor> drunkLiquors = <Liquor>[].obs;
  RxDouble percentageInBlood = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadLiquors();
  }

  Future<void> addLiquor(String name, double percentage, int volume) async {
    drunkLiquors.add(
      Liquor(name, percentage, volume),
    );

    calculatePercentageInBlood();
    updateSharedPreferences();
  }

  Future<void> loadLiquors() async {
    final prefs = await SharedPreferences.getInstance();

    final String? liquorsString = await prefs.getString('drunk_liquors');

    if (liquorsString != null) {
      drunkLiquors.value = Liquor.decode(liquorsString);
      calculatePercentageInBlood();
    }
  }

  Future<void> updateSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = Liquor.encode(drunkLiquors);

    await prefs.setString('drunk_liquors', encodedData);
  }

  //wartości z dupy
  void calculatePercentageInBlood() {
    double alcoholSum = 0;
    for (Liquor liquor in drunkLiquors) {
      alcoholSum += liquor.percentage * liquor.volume / 1000;
    }

    //brać pod uwagę wagę
    percentageInBlood.value = alcoholSum / 50;
  }
}
