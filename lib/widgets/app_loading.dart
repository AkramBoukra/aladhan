import 'package:aladhan/bricks/my_widgets/dotted_loading_indicator.dart';
import 'package:aladhan/settings/app_theme.dart';
import 'package:aladhan/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppCard(
        hMargin: MediaQuery.of(context).size.width / 4,
        vPadding: 30,
        color: Theme.of(context).cardColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: DottedCircularProgressIndicatorFb(
                defaultDotColor:
                    Theme.of(context).primaryColor.withOpacity(0.7),
                currentDotColor:
                    Theme.of(context).primaryColor.withOpacity(0.3),
                numDots: 9,
                dotSize: 5,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Attendez un moment...",
              style: AppTextStyle.small,
            )
          ],
        ),
      ),
    );
  }
}
