import 'dart:developer';

import 'package:aladhan/notifications/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final RxInt totalNotifications = 0.obs;
  final Rx<PushNotification?> notificationInfo = PushNotification().obs;

  @override
  void onInit() {
    pushFCMToken();
    initMessaging();
    checkForInitialMessage();

    FirebaseMessaging.onMessage.listen(handleNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    super.onInit();
  }

  Future<void> pushFCMToken() async {
    String? token = await _messaging.getToken();
    print('FCM Token: $token');
  }

  void initMessaging() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("L'utilisateur a obtenu l'autorisation de recevoir des notifications");

      print("Configuration des gestionnaires de messages");

      log('Écoute des messages au premier plan');

      log("Écoute des messages d'arrière-plan");
    } else {
      print("L'utilisateur a refusé l'autorisation de recevoir des notifications");
    }
  }

  Future<void> checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleNotification(initialMessage);
    }
  }

  void handleNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      PushNotification pushNotification = PushNotification(
        title: notification.title,
        body: notification.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      notificationInfo.value = pushNotification;
      totalNotifications.value++;

      log('Received notification: ${notification.title}');
    }

    if (notificationInfo.value != null) {
      showSimpleNotification(
        Text(notificationInfo.value!.title ?? ''),
        leading: NotificationBadge(
          totalNotifications: totalNotifications.value,
        ),
        subtitle: Text(notificationInfo.value!.body ?? ''),
        background: Colors.cyan.shade700,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling background message: ${message.messageId}");
  }
}

class PushNotification {
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;

  PushNotification({this.title, this.body, this.dataTitle, this.dataBody});
}
