import 'dart:async';
import 'dart:developer';

import 'package:aladhan/controllers/prayer_time_controller.dart';
import 'package:aladhan/controllers/prayer_time_notif_controller.dart';
import 'package:aladhan/notifications/notification_service.dart';
import 'package:aladhan/settings/app_theme.dart';
import 'package:aladhan/widgets/app_card.dart';
import 'package:aladhan/widgets/prayer_time_card.dart';
import 'package:aladhan/widgets/prayer_time_shimmer.dart';
import 'package:aladhan/widgets/select_time.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';

class Prayer extends StatelessWidget {
  Prayer({Key? key}) : super(key: key);

  final prayerTimeC = Get.put(PrayerTimeControllerImpl());
  final prayerTimeNotifC = Get.put(PrayerTimeNotifController());
  final groupBtnController = GroupButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          toNextPrayer();
        },
        backgroundColor: Theme.of(context).cardColor,
        color: Theme.of(context).primaryColor,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: Obx(() {
          return prayerTimeC.isLoadLocation.value
              ? const SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: PrayerTimePageShimmer(),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const Text(
                        "Aujourd'hui",
                        style: AppTextStyle.title,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'prayer_time_card',
                        child: PrayerTimeCard(prayerTimeC: prayerTimeC),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() {
                        var time = prayerTimeC.prayerTimesToday.value;
                        var shubuh = time.shubuh;
                        var sunrise = time.sunrise;
                        var dhuhur = time.dhuhur;
                        var ashar = time.ashar;
                        var maghrib = time.maghrib;
                        var isha = time.isya;

                        List<DateTime?> prayerTimes = [
                          shubuh,
                          sunrise,
                          dhuhur,
                          ashar,
                          maghrib,
                          isha,
                        ];

                        List<bool> enableNotif = [
                          prayerTimeNotifC.enableFajr.value,
                          prayerTimeNotifC.enableSunrise.value,
                          prayerTimeNotifC.enableDhuhr.value,
                          prayerTimeNotifC.enableAsr.value,
                          prayerTimeNotifC.enableMaghrib.value,
                          prayerTimeNotifC.enableIsha.value,
                          prayerTimeNotifC.enableQiyam.value,
                        ];

                        List prayerNames = [
                          "FAJR",
                          "LEVER DU SOLEIL",
                          "DHOR",
                          "ASR",
                          "MAGHRIB",
                          "ISHA",
                          "QIYAM",
                        ];

                        return FadeInDown(
                          from: 40,
                          child: AppCard(
                            hMargin: 0,
                            child: SizedBox(
                              height: 432,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${prayerTimes[i]?.hour.toString().padLeft(2, '0') ?? "--"}:${prayerTimes[i]?.minute.toString().padLeft(2, '0') ?? "--"}",
                                        style: AppTextStyle.normal.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Chip(
                                        labelPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        backgroundColor: Get.isDarkMode
                                            ? Theme.of(context)
                                                .cardColor
                                                .withOpacity(0.7)
                                            : Colors.green.withOpacity(0.1),
                                        label: Text(
                                          prayerNames[i],
                                          style: AppTextStyle.small.copyWith(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${prayerTimes[i]?.day.toString().padLeft(2, '0') ?? "--"}/${prayerTimes[i]?.month.toString().padLeft(2, '0') ?? "--"}",
                                        style: AppTextStyle.small.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () {
                                          groupBtnController.unselectAll();
                                          switch (i) {
                                            case 0:
                                              if (prayerTimeNotifC
                                                  .enableFajr.isTrue) {
                                                cancelScheduleNotification(
                                                  prayerTimeNotifC.fajrId.value,
                                                  "FAJR",
                                                ).then((_) {
                                                  // Change notif icon
                                                  prayerTimeNotifC
                                                          .enableFajr.value =
                                                      !prayerTimeNotifC
                                                          .enableFajr.value;

                                                  // save to local db
                                                  prayerTimeNotifC.writeBox(
                                                    key: 'fajr_notif',
                                                    value: prayerTimeNotifC
                                                        .enableFajr.value
                                                        .toString(),
                                                  );
                                                });
                                              } else {
                                                showSetPrayerTime(
                                                  prayerTime: prayerTimes[0]!,
                                                  prayerName: prayerNames[0],
                                                );
                                              }
                                              break;
                                            case 1:
                                              if (prayerTimeNotifC
                                                  .enableSunrise.isTrue) {
                                                cancelScheduleNotification(
                                                  prayerTimeNotifC
                                                      .sunriseId.value,
                                                  "LEVER DU SOLEIL",
                                                ).then((_) {
                                                  // Change notif icon
                                                  prayerTimeNotifC
                                                          .enableSunrise.value =
                                                      !prayerTimeNotifC
                                                          .enableSunrise.value;

                                                  prayerTimeNotifC.writeBox(
                                                    key: 'sunrise_notif',
                                                    value: prayerTimeNotifC
                                                        .enableSunrise.value
                                                        .toString(),
                                                  );
                                                });
                                              } else {
                                                showSetPrayerTime(
                                                  prayerTime: prayerTimes[1]!,
                                                  prayerName: prayerNames[1],
                                                );
                                              }
                                              break;
                                            case 2:
                                              if (prayerTimeNotifC
                                                  .enableDhuhr.isTrue) {
                                                cancelScheduleNotification(
                                                  prayerTimeNotifC
                                                      .dhuhrId.value,
                                                  "DHOR",
                                                ).then((_) {
                                                  // Change notif icon
                                                  prayerTimeNotifC
                                                          .enableDhuhr.value =
                                                      !prayerTimeNotifC
                                                          .enableDhuhr.value;

                                                  prayerTimeNotifC.writeBox(
                                                    key: 'dhuhr_notif',
                                                    value: prayerTimeNotifC
                                                        .enableDhuhr.value
                                                        .toString(),
                                                  );
                                                });
                                              } else {
                                                showSetPrayerTime(
                                                  prayerTime: prayerTimes[2]!,
                                                  prayerName: prayerNames[2],
                                                );
                                              }
                                              break;
                                            case 3:
                                              if (prayerTimeNotifC
                                                  .enableAsr.isTrue) {
                                                cancelScheduleNotification(
                                                  prayerTimeNotifC.asrId.value,
                                                  "ASR",
                                                ).then((_) {
                                                  // Change notif icon
                                                  prayerTimeNotifC
                                                          .enableAsr.value =
                                                      !prayerTimeNotifC
                                                          .enableAsr.value;

                                                  prayerTimeNotifC.writeBox(
                                                    key: 'asr_notif',
                                                    value: prayerTimeNotifC
                                                        .enableAsr.value
                                                        .toString(),
                                                  );
                                                });
                                              } else {
                                                showSetPrayerTime(
                                                  prayerTime: prayerTimes[3]!,
                                                  prayerName: prayerNames[3],
                                                );
                                              }
                                              break;
                                            case 4:
                                              if (prayerTimeNotifC
                                                  .enableMaghrib.isTrue) {
                                                cancelScheduleNotification(
                                                  prayerTimeNotifC
                                                      .maghribId.value,
                                                  "MAGHRIB",
                                                ).then((_) {
                                                  // Change notif icon
                                                  prayerTimeNotifC
                                                          .enableMaghrib.value =
                                                      !prayerTimeNotifC
                                                          .enableMaghrib.value;

                                                  prayerTimeNotifC.writeBox(
                                                    key: 'maghrib_notif',
                                                    value: prayerTimeNotifC
                                                        .enableMaghrib.value
                                                        .toString(),
                                                  );
                                                });
                                              } else {
                                                showSetPrayerTime(
                                                  prayerTime: prayerTimes[4]!,
                                                  prayerName: prayerNames[4],
                                                );
                                              }
                                              break;
                                            case 5:
                                              if (prayerTimeNotifC
                                                  .enableIsha.isTrue) {
                                                cancelScheduleNotification(
                                                  prayerTimeNotifC.ishaId.value,
                                                  "ISHA",
                                                ).then((_) {
                                                  // Change notif icon
                                                  prayerTimeNotifC
                                                          .enableIsha.value =
                                                      !prayerTimeNotifC
                                                          .enableIsha.value;

                                                  prayerTimeNotifC.writeBox(
                                                    key: 'isha_notif',
                                                    value: prayerTimeNotifC
                                                        .enableIsha.value
                                                        .toString(),
                                                  );
                                                });
                                              } else {
                                                showSetPrayerTime(
                                                  prayerTime: prayerTimes[5]!,
                                                  prayerName: prayerNames[5],
                                                );
                                              }
                                              break;
                                            case 6:
                                              if (prayerTimeNotifC
                                                  .enableQiyam.isTrue) {
                                                cancelScheduleNotification(
                                                  prayerTimeNotifC
                                                      .qiyamId.value,
                                                  "QIYAM",
                                                ).then((_) {
                                                  // Change notif icon
                                                  prayerTimeNotifC
                                                          .enableQiyam.value =
                                                      !prayerTimeNotifC
                                                          .enableQiyam.value;

                                                  prayerTimeNotifC.writeBox(
                                                    key: 'qiyam_notif',
                                                    value: prayerTimeNotifC
                                                        .enableQiyam.value
                                                        .toString(),
                                                  );
                                                });
                                              } else {
                                                showSetPrayerTime(
                                                  prayerTime: prayerTimes[6]!,
                                                  prayerName: prayerNames[6],
                                                );
                                              }
                                              break;
                                            default:
                                          }
                                        },
                                        icon: Icon(
                                          enableNotif[i]
                                              ? Icons
                                                  .notifications_active_outlined
                                              : Icons
                                                  .notifications_off_outlined,
                                          color: enableNotif[i]
                                              ? null
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, i) {
                                  return const Divider();
                                },
                                itemCount: prayerTimes.length,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
        }),
      ),
    );
  }

  Future<void> activeScheduleNotification(
      int? hour, int? minute, DateTime prayerTime, String prayerName) async {
    if (hour != null && minute != null) {
      log("HORAIRE ACTIF ${prayerName.toUpperCase()}");

      prayerTimeNotifC.createPrayerTimeReminder(
        prayerTime: prayerName,
        dateTime: DateTime.now(),
        hour: hour,
        minute: minute,
      );

      if (prayerName == 'FAJR') {
        // Change notif icon
        prayerTimeNotifC.enableFajr.value = !prayerTimeNotifC.enableFajr.value;

        // save to local db
        prayerTimeNotifC.writeBox(
          key: 'fajr_notif',
          value: prayerTimeNotifC.enableFajr.value.toString(),
        );
      } else if (prayerName == 'LEVER DU SOLEIL') {
        // Change notif icon
        prayerTimeNotifC.enableSunrise.value =
            !prayerTimeNotifC.enableSunrise.value;

        prayerTimeNotifC.writeBox(
          key: 'sunrise_notif',
          value: prayerTimeNotifC.enableSunrise.value.toString(),
        );
      } else if (prayerName == 'DHOR') {
        // Change notif icon
        prayerTimeNotifC.enableDhuhr.value =
            !prayerTimeNotifC.enableDhuhr.value;

        prayerTimeNotifC.writeBox(
          key: 'dhuhr_notif',
          value: prayerTimeNotifC.enableDhuhr.value.toString(),
        );
      } else if (prayerName == 'ASR') {
        // Change notif icon
        prayerTimeNotifC.enableAsr.value = !prayerTimeNotifC.enableAsr.value;

        prayerTimeNotifC.writeBox(
          key: 'asr_notif',
          value: prayerTimeNotifC.enableAsr.value.toString(),
        );
      } else if (prayerName == 'MAGHRIB') {
        // Change notif icon
        prayerTimeNotifC.enableMaghrib.value =
            !prayerTimeNotifC.enableMaghrib.value;

        prayerTimeNotifC.writeBox(
          key: 'maghrib_notif',
          value: prayerTimeNotifC.enableMaghrib.value.toString(),
        );
      } else if (prayerName == 'ISHA') {
        // Change notif icon
        prayerTimeNotifC.enableIsha.value = !prayerTimeNotifC.enableIsha.value;

        prayerTimeNotifC.writeBox(
          key: 'isha_notif',
          value: prayerTimeNotifC.enableIsha.value.toString(),
        );
      } else if (prayerName == 'QIYAM') {
        // Change notif icon
        prayerTimeNotifC.enableQiyam.value =
            !prayerTimeNotifC.enableQiyam.value;

        prayerTimeNotifC.writeBox(
          key: 'qiyam_notif',
          value: prayerTimeNotifC.enableQiyam.value.toString(),
        );
      }
      Get.back();
    } else {
      Get.back();
      Get.snackbar("Oups...",
          "Définissez le rappel des heures de prière pour activer la notification de rappel.");
    }
  }

  Future<void> cancelScheduleNotification(int id, String prayerName) async {
    if (id != 0) {
      log("ANNULER LE HORAIRE ${prayerName.toUpperCase()}");
      await AwesomeNotify.cancelScheduledNotificationById(
        id,
      );
    }
  }

  void toNextPrayer() {
    prayerTimeC.getLocation().then((_) {
      prayerTimeC.cT.restart(duration: prayerTimeC.leftOver.value);
    });
  }

  void showSetPrayerTime(
      {required DateTime prayerTime, required String prayerName}) {
    int? hour, minute;

    log(prayerName);

    Get.bottomSheet(
      SelectTime(
        controller: groupBtnController,
        onSelected: (value, index, selected) {
          switch (index) {
            case 0:
              hour = 0;
              minute = 0; // in second
              break;
            case 1:
              hour = 0;
              minute = 300; // in second
              break;
            case 2:
              hour = 0;
              minute = 600; // in second
              break;
            case 3:
              hour = 0;
              minute = 900; // in second
              break;
            case 4:
              hour = 0;
              minute = 1200; // in second
              break;
            default:
              throw Exception('Invalid index: $index');
          }
        },
        onPressed: () {
          activeScheduleNotification(hour, minute, prayerTime, prayerName);
        },
      ),
    );
  }
}
