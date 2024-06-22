import 'package:aladhan/screen/coran.dart';
import 'package:aladhan/screen/prayer.dart';
import 'package:aladhan/screen/qibla.dart';
import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController{
  RxInt index = 0.obs;

  var pages =[
    Prayer(),
    Qibla(),
    Coran()
  ];
}