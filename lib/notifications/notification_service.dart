// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';

class AwesomeNotify {
  static int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000).abs();
  }

  static Future<bool> createBasicNotif({
    required String title,
    required String body,
    required int id,
  }) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) {
      return await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: "basic_notif",
          title: title,
          body: body,
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.BigPicture,
        ),
      );
    }
    return false;
  }

  static Future<bool> createScheduleNotif({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    int? hour,
    int? minute,
  }) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed && title != null && body != null && dateTime.isAfter(DateTime.now())) {
      dateTime = dateTime.subtract(Duration(hours: hour ?? 0, minutes: minute ?? 0));
      log("DateHeure Après : $dateTime");

      return await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: "schedule_notif",
          title: title,
          body: body,
          notificationLayout: NotificationLayout.BigPicture,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          criticalAlert: true,
          fullScreenIntent: (minute == 0),
        ),
        actionButtons: (minute == 0)
            ? [
                NotificationActionButton(
                  key: "mark_done",
                  label:"Mark Done",
                )
              ]
            : null,
        schedule: NotificationCalendar(
          year: dateTime.year,
          month: dateTime.month,
          day: dateTime.day,
          hour: dateTime.hour,
          minute: dateTime.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          preciseAlarm: true,
        ),
      );
    }
    return false;
  }

  static Future<void> cancelScheduledNotificationById(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future<void> cancelScheduledNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }
}
