import 'package:aladhan/helper/result.dart';

class LocationResultFormatter extends ResultFormatter {
  final bool result;

  LocationResultFormatter(this.result, String? error) : super(error);
}
