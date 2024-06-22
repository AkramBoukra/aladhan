import 'package:aladhan/settings/app_theme.dart';
import 'package:aladhan/settings/settings_controller.dart';
import 'package:aladhan/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

class ThemePage extends StatelessWidget {
  ThemePage({Key? key}) : super(key: key);

  final settingController = Get.put(SettingsController());

  final List<String> _listNameColor = [
    "Azure",
    "Go Green",
    "Sapphire",
    "Medium Pupple",
    "French Pink"
  ];
  final List<Color> _listColor = [
    ColorPalletes.azure,
    ColorPalletes.goGreen,
    ColorPalletes.sapphire,
    ColorPalletes.mediumPurple,
    ColorPalletes.frenchPink
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "App Themes",
          style: AppTextStyle.bigTitle,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    settingController.setPrimaryColor(
                        _listColor[i], _listNameColor[i]);
                    settingController.setThemePrimaryColor(_listColor[i],
                        key: _listNameColor[i]);
                  },
                  child: AppCard(
                    child: Row(
                      children: [
                        Obx(
                          () => Container(
                            height: 30,
                            width: 30,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: _listColor[i],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: (settingController.primaryColor.value ==
                                    _listColor[i])
                                ? const Icon(
                                    UniconsLine.check,
                                    color: Colors.white,
                                  )
                                : const SizedBox(),
                          ),
                        ),
                        Text(
                          _listNameColor[i],
                          style: AppTextStyle.normal,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, i) {
                return const SizedBox(height: 10);
              },
              itemCount: _listColor.length,
            ),
          )
        ],
      ),
    );
  }
}
