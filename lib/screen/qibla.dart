import 'dart:math';

import 'package:aladhan/controllers/prayer_time_controller.dart';
import 'package:aladhan/settings/app_theme.dart';
import 'package:aladhan/widgets/app_loading.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:get/get.dart';

class Qibla extends StatefulWidget {
  const Qibla({Key? key}) : super(key: key);

  @override
  _QiblaState createState() => _QiblaState();
}

class _QiblaState extends State<Qibla> {
  final prayerTimeC = Get.put(PrayerTimeControllerImpl());

  @override
  void initState() {
    super.initState();
    prayerTimeC.checkDeviceSensorSupport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => !prayerTimeC.isQiblahLoaded.value
            ? const AppLoading()
            : (prayerTimeC.sensorIsSupported.value)
                ? StreamBuilder<QiblahDirection?>(
                    stream: FlutterQiblah.qiblahStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final qiblahDirection = snapshot.data;
                      print("Direction: ${qiblahDirection?.direction}");
                      print("Qiblah: ${qiblahDirection?.qiblah}");

                      double direction =
                          (qiblahDirection?.direction ?? 0) * (pi / 180) * -1;

                      double qiblah =
                          (qiblahDirection?.qiblah ?? 0) * (pi / 180) * -1;

                      return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Text(
                                "🎯\n"
                                "${prayerTimeC.qiblahDirection.value.toStringAsFixed(0)}°",
                                style: AppTextStyle.bigTitle.copyWith(
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 70),
                            FadeIn(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(200),
                                      ),
                                      child: Container(
                                        height: 200,
                                        width: 200,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Transform.rotate(
                                          angle: direction,
                                          child: Image.asset(
                                            "assets/compass_bg.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Transform.rotate(
                                      angle: qiblah,
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          FadeIn(
                                            child: Image.asset(
                                              "assets/kaaba.png",
                                              width: 60,
                                              cacheHeight: 200,
                                              cacheWidth: 200,
                                            ),
                                          ),
                                          Container(
                                            height: 300,
                                            width: 8,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                stops: const [
                                                  0.1,
                                                  0.5,
                                                ],
                                                colors: [
                                                  Get.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black
                                                          .withOpacity(.5),
                                                  Colors.white.withOpacity(0.0),
                                                ],
                                              ),
                                              // color: Theme.of(context).primaryColor.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text("Cette plateforme n'est pas prise en charge"),
                  ),
      ),
    );
  }
}
