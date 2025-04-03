import 'package:flutter/widgets.dart';

class AppConstants {
  static double fontCity(BuildContext context) {
    return MediaQuery.of(context).size.width > 600 ? 24 : 18;
  }
    static double fontDetail(BuildContext context) {
    return MediaQuery.of(context).size.width > 600 ? 18 : 16;
  }

  static double sizeIcon(BuildContext context) {
    return MediaQuery.of(context).size.width > 600 ? 150 : 100;
  }
}
