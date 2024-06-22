import 'package:aladhan/controllers/bottom_nav_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class GoogleNavBar extends StatefulWidget {
  const GoogleNavBar({super.key});

  @override
  State<StatefulWidget> createState() => _GoogleNavBarState();
}

class _GoogleNavBarState extends State<GoogleNavBar> {
  @override
  Widget build(BuildContext context) {
    BottomNavigationBarController controller =
        Get.put(BottomNavigationBarController());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
        ),
        body: Obx(
          () => controller.pages[controller.index.value],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.green,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                onTabChange: (value) {
                  controller.index.value = value;
                },
                tabs: const [
                  GButton(
                    icon: FlutterIslamicIcons.prayingPerson,
                    text: "Priéres",
                  ),
                  GButton(
                    icon: FlutterIslamicIcons.qibla,
                    text: "Qibla",
                  ),
                  GButton(
                    icon: FlutterIslamicIcons.quran2,
                    text: "Coran",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
