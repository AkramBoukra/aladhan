import 'dart:async';
import 'dart:developer';

import 'package:adhan/adhan.dart';
import 'package:aladhan/widgets/app_permission_statuts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart' as unicons;
import 'package:aladhan/formatter/result_formatter.dart';
import 'package:aladhan/models/prayer_time_model.dart';

class _CurrentLocation {
  double latitude;
  double longitude;

  _CurrentLocation({this.latitude = 0, this.longitude = 0});
}

const String _kLocationServicesDisabledMessage =
    'Les services de localisation sont désactivés.';
const String _kPermissionDeniedMessage = 'Permission refusée.';
const String _kPermissionDeniedForverMessage =
    "Veuillez activer l'autorisation de localisation de cette application dans les paramètres pour utiliser cette fonctionnalité.";
const String _kPermissionGrantedMessage = 'Permission accordée.';

abstract class PrayerTimeController extends GetxController {
  Future<LocationResultFormatter> handleLocationPermission();
  Future<bool> openAppSetting();
  Future<void> getLocation();
  void getPrayerTimesToday(double latitude, double longitude);
  void getAddressLocationDetail(double latitude, double longitude);
  void setScheduleId(String prayerTime, int id);
}

class PrayerTimeControllerImpl extends PrayerTimeController {
  var currentLocation = _CurrentLocation().obs;
  var prayerTimesToday = PrayerTime().obs;
  var nextPrayer = Prayer.none.obs;
  var currentPrayer = Prayer.none.obs;
  var currentAddress = const Placemark().obs;
  var leftOver = 0.obs;
  var sensorIsSupported = false.obs;
  var qiblahDirection = 0.0.obs;
  final cT = CountDownController();
  var isLoadLocation = false.obs;
  var fajrId = 0.obs;
  var sunriseId = 0.obs;
  var dhuhrId = 0.obs;
  var asrId = 0.obs;
  var maghribId = 0.obs;
  var ishaId = 0.obs;
  var qiyamId = 0.obs;

  @override
  Future<LocationResultFormatter> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationResultFormatter(false, _kLocationServicesDisabledMessage);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResultFormatter(false, _kPermissionDeniedMessage);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationResultFormatter(false, _kPermissionDeniedForverMessage);
    }

    return LocationResultFormatter(true, _kPermissionGrantedMessage);
  }

  @override
  Future<bool> openAppSetting() async {
    final opened = await Geolocator.openAppSettings();
    if (opened) {
      log("Paramètre d'emplacement ouvert");
    } else {
      log("Erreur lors de l'ouverture du paramètre d'emplacement");
    }

    return opened;
  }

  @override
  Future<void> getLocation() async {
    isLoadLocation.value = true;
    final handlePermission = await handleLocationPermission();

    if (!handlePermission.result) {
      Get.bottomSheet(
        AppPermissionStatus(
          icon: unicons.UniconsLine.map_marker_slash,
          title: "Autoriser l'accès à l'emplacement",
          message: handlePermission.error?.toString() ?? "erreur inconue",
          onPressed: () {
            final prayerC = Get.find<PrayerTimeControllerImpl>();
            prayerC.openAppSetting().then((value) {
              if (!value) {
                Get.snackbar("Oups", "Impossible d'ouvrir le paramètre");
              }
            });
          },
        ),
      );
    } else {
      final location = await Geolocator.getCurrentPosition();
      var loc = _CurrentLocation(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      currentLocation(loc);
      getPrayerTimesToday(location.latitude, location.longitude);
      getAddressLocationDetail(location.latitude, location.longitude);

      isLoadLocation.value = false;

      getQiblah(location.latitude, location.longitude);
      log('Location Obtained: Latitude ${location.latitude}, Longitude ${location.longitude}');
    }
  }

  @override
  void getPrayerTimesToday(double latitude, double longitude) {
    final myCoordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.muslim_world_league.getParameters();
    params.madhab = Madhab.shafi;
    final prayerTimes = PrayerTimes.today(myCoordinates, params);
    final sunnahTimes = SunnahTimes(prayerTimes);

    var result = PrayerTime(
      shubuh: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhur: prayerTimes.dhuhr,
      ashar: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isya: prayerTimes.isha,
      middleOfTheNight: sunnahTimes.middleOfTheNight,
      lastThirdOfTheNight: sunnahTimes.lastThirdOfTheNight,
    );

    currentPrayer(prayerTimes.currentPrayer());
    nextPrayer(prayerTimes.nextPrayer());
    prayerTimesToday(result);
  }

  @override
  void getAddressLocationDetail(double latitude, double longitude) async {
    try {
      final placeMarks = await placemarkFromCoordinates(latitude, longitude);
      var address = placeMarks[0];
      currentAddress(address);
    } on PlatformException catch (e) {
      log(e.toString());
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        final placeMarks = await placemarkFromCoordinates(latitude, longitude);
        var address = placeMarks[0];
        currentAddress(address);
      } catch (e) {
        Get.snackbar("Oups",
            "L'adresse n'a pas été récupérée, veuillez la remplir manuellement");
      }
    }
  }

  var isQiblahLoaded = false.obs;

  void getQiblah(double latitude, double longitude) {
    final myCoordinates = Coordinates(latitude, longitude);
    final qiblah = Qibla(myCoordinates);
    qiblahDirection.value = qiblah.direction;
    log('Qiblah Direction: ${qiblah.direction}');
  }

  Future<void> checkDeviceSensorSupport() async {
    FlutterQiblah.androidDeviceSensorSupport().then((value) {
      if (value != null && value) {
        sensorIsSupported.value = value;
        isQiblahLoaded.value = true;
      }
      log("Check Device Sensor Support: $value");
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await checkDeviceSensorSupport();
    await getLocation();
  }

  @override
  void setScheduleId(String prayerTime, int id) {
    log("Set ID : $prayerTime $id");
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
}
