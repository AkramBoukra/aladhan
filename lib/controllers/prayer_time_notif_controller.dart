import 'package:aladhan/notifications/notification_service.dart';
import 'package:aladhan/widgets/app_permission_statuts.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unicons/unicons.dart';

class PrayerTimeNotifController extends GetxController {
  var enableFajr = false.obs;
  var enableSunrise = false.obs;
  var enableDhuhr = false.obs;
  var enableAsr = false.obs;
  var enableMaghrib = false.obs;
  var enableIsha = false.obs;
  var enableQiyam = false.obs;

  var fajrId = 0.obs;
  var sunriseId = 0.obs;
  var dhuhrId = 0.obs;
  var asrId = 0.obs;
  var maghribId = 0.obs;
  var ishaId = 0.obs;
  var qiyamId = 0.obs;

  void setScheduleId(String prayerTime, int id) {
    switch (prayerTime.toLowerCase()) {
      case 'fajr':
        fajrId.value = id;
        break;
      case 'lever du soleil':
        sunriseId.value = id;
        break;
      case 'dhuhr':
        dhuhrId.value = id;
        break;
      case 'asr':
        asrId.value = id;
        break;
      case 'maghrib':
        maghribId.value = id;
        break;
      case 'isha':
        ishaId.value = id;
        break;
      case 'qiyam':
        qiyamId.value = id;
        break;
      default:
        break;
    }
  }

  void createPrayerTimeNotif(String prayerTime) {
    final int uniqueId = AwesomeNotify.createUniqueId();

    AwesomeNotify.createBasicNotif(
      id: uniqueId,
      title: "Horaires de prière",
      body: "${prayerTime.capitalize} l'heure de la prière est arrivée 🤩",
    ).then((value) {
      if (!value) {
        Get.snackbar("Oups", "Notification non autorisée");
      }
    });
  }

  void createPrayerTimeReminder({
    required String prayerTime,
    required DateTime dateTime,
    required int hour,
    required int minute,
  }) {
    final int uniqueId = AwesomeNotify.createUniqueId();
    setScheduleId(prayerTime, uniqueId);

    int prayerHour = dateTime.hour;
    int prayerMinute = dateTime.minute;

    AwesomeNotify.createScheduleNotif(
      id: uniqueId,
      title: "Rappel des heures de prière",
      body: minute != 0
          ? "${prayerTime.capitalize} l'heure de la prière arrive bientôt ${Duration(seconds: minute).inMinutes} minutes, préparons-nous 🤩"
          : "${prayerTime.capitalize} l'heure de la prière est arrivée, faisons la prière 🚀",
      dateTime: dateTime,
      hour: prayerHour,
      minute: prayerMinute,
    ).then((bool value) {
      if (!value) {
        Get.bottomSheet(
          AppPermissionStatus(
            icon: Icons.notifications_none,
            title: "Autoriser les notifications",
            message:
                "Notre application souhaite vous envoyer des notifications.",
            onPressed: () {
              AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then(
                    (value) => Get.back(),
                  );
            },
          ),
        );
      }
    });
  }

  void writeBox({required String key, required String value}) async {
    final box = Get.find<GetStorage>();
    await box.write(key, value);
  }

  bool readBox({required String key}) {
    final box = Get.find<GetStorage>();
    final value = box.read(key);
    if (value != null) {
      return value == 'true';
    }
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    enableFajr = readBox(key: 'fajr_notif').obs;
    enableSunrise = readBox(key: 'sunrise_notif').obs;
    enableDhuhr = readBox(key: 'dhuhr_notif').obs;
    enableAsr = readBox(key: 'asr_notif').obs;
    enableMaghrib = readBox(key: 'maghrib_notif').obs;
    enableIsha = readBox(key: 'isha_notif').obs;
    enableQiyam = readBox(key: 'qiyam_notif').obs;

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        Get.bottomSheet(
          AppPermissionStatus(
            icon: UniconsLine.bell_slash,
            title: "Autoriser les notifications",
            message:
                "Notre application souhaite vous envoyer des notifications.",
            onPressed: () {
              AwesomeNotifications()
                  .requestPermissionToSendNotifications()
                  .then(
                    (value) => Get.back(),
                  );
            },
          ),
        );
      }
    });
  }
}
