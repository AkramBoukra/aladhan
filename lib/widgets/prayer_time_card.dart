import 'package:adhan/adhan.dart';
import 'package:aladhan/controllers/prayer_time_controller.dart';
import 'package:aladhan/settings/app_theme.dart';
import 'package:aladhan/widgets/app_card.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

class PrayerTimeCard extends StatelessWidget {
  const PrayerTimeCard({Key? key, required this.prayerTimeC}) : super(key: key);
  final PrayerTimeControllerImpl prayerTimeC;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(25),
      child: Obx(() {
        final prayer = prayerTimeC.nextPrayer.value;
        final time = prayerTimeC.prayerTimesToday.value;
        final address = prayerTimeC.currentAddress.value;
        int? nextH, nextM;
        int duration = 0;
        int initDuration = 0;

        switch (prayer) {
          case Prayer.fajr:
            nextH = time.shubuh?.hour;
            nextM = time.shubuh?.minute;
            duration =
                time.lastThirdOfTheNight!.difference(time.shubuh!).inSeconds;
            break;
          case Prayer.dhuhr:
            nextH = time.dhuhur?.hour;
            nextM = time.dhuhur?.minute;
            duration = time.dhuhur!.difference(DateTime.now()).inSeconds;
            break;
          case Prayer.asr:
            nextH = time.ashar?.hour;
            nextM = time.ashar?.minute;
            duration = time.ashar!.difference(DateTime.now()).inSeconds;
            break;
          case Prayer.maghrib:
            nextH = time.maghrib?.hour;
            nextM = time.maghrib?.minute;
            duration = time.maghrib!.difference(DateTime.now()).inSeconds;
            break;
          case Prayer.isha:
            nextH = time.isya?.hour;
            nextM = time.isya?.minute;
            duration = time.isya!.difference(DateTime.now()).inSeconds;
            break;
          case Prayer.sunrise:
            nextH = time.sunrise?.hour;
            nextM = time.sunrise?.minute;
            duration = time.sunrise!.difference(DateTime.now()).inSeconds;
            break;
          case Prayer.none:
            nextH = time.lastThirdOfTheNight?.hour;
            nextM = time.lastThirdOfTheNight?.minute;
            if (time.lastThirdOfTheNight != null) {
              initDuration = time.lastThirdOfTheNight!
                  .difference(DateTime.now())
                  .inSeconds;
              duration =
                  time.isya!.difference(time.lastThirdOfTheNight!).inSeconds;
            }
            break;
          default:
            throw Exception('Unhandled prayer value: $prayer');
        }

        if (prayerTimeC.leftOver.value == 0) {
          prayerTimeC.leftOver.value = duration;
        }

        // convert negative value to positive
        if (duration.isNegative) duration = duration * -1;

        if (initDuration < duration) {
          initDuration = duration - initDuration;
        }

        if (initDuration > duration) initDuration = duration;

        if (initDuration == duration) {
          initDuration = duration - initDuration;
        }

        final hour = nextH != null ? nextH.toString().padLeft(2, '0') : "--";
        final minute = nextM != null ? nextM.toString().padLeft(2, '0') : "--";

        return AppCard(
          hMargin: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$hour:$minute",
                    style: AppTextStyle.title.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 2),
                  Obx(
                    () => Text.rich(
                      TextSpan(
                        text: (nextH != null &&
                                prayerTimeC.nextPrayer.value.name == "none")
                            ? "Qiyam"
                            : (nextH == null)
                                ? ""
                                : prayerTimeC
                                    .nextPrayer.value.name.capitalizeFirst,
                        children: [
                          const TextSpan(text: " - "),
                          TextSpan(
                            text: address.isBlank! ? "" : address.country,
                            style: AppTextStyle.normal.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      style: AppTextStyle.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        UniconsLine.user_location,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${address.subLocality ?? "--"},",
                            style: AppTextStyle.small.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            address.locality ?? "--",
                            style: AppTextStyle.small.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              CircularCountDownTimer(
                width: MediaQuery.of(context).size.width * 0.18,
                height: MediaQuery.of(context).size.width * 0.18,
                duration: duration,
                initialDuration: initDuration,
                controller: prayerTimeC.cT,
                fillColor: Colors.green,
                backgroundColor: Colors.green.withOpacity(0.2),
                ringColor: Colors.green.withOpacity(0.1),
                strokeCap: StrokeCap.round,
                textStyle: AppTextStyle.small.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                isReverse: true,
                onComplete: () async {
                  prayerTimeC.leftOver.value = 0;
                  await Future.delayed(2.seconds);
                  prayerTimeC.getLocation().then((_) {
                    prayerTimeC.cT
                        .restart(duration: prayerTimeC.leftOver.value);
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
