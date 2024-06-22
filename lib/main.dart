import 'package:aladhan/firebase_options.dart';
import 'package:aladhan/gnav/gnav_bar.dart';
import 'package:aladhan/settings/app_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  String? supabaseUrl = dotenv.get("SUPABASE_URL");
  String? supabaseAnonKey = dotenv.get("SUPABASE_ANON_KEY");

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_notif",
        channelName: "Basic Notifications",
        channelDescription: "Basic notifications of aladhan",
        channelShowBadge: true,
        defaultColor: ColorPalletes.azure,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        channelKey: "schedule_notif",
        channelName: "Schedule Notifications",
        channelDescription: "Schedule notifications of aladhan",
        channelShowBadge: true,
        locked: true,
        defaultColor: ColorPalletes.azure,
        importance: NotificationImportance.High,
      )
    ],
  );

  // Firebase initialization
  await Firebase.initializeApp(
    name: 'aladhan',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Supabase initialization
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Local storage initialization
  await GetStorage.init();
  Get.lazyPut(() => GetStorage());

  runApp(const MyApp());
  await initNotifications();
}

Future<void> initNotifications() async {
  // Demande d'autorisation de notification
  await AwesomeNotifications().requestPermissionToSendNotifications();
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
        debugShowCheckedModeBanner: false, home: GoogleNavBar());
  }
}
