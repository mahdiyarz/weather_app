import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppBackground {
  static AssetImage getBackGroundImage() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('kk').format(now);

    if (6 > int.parse(formattedTime)) {
      return const AssetImage('assets/images/night.jpg');
    } else if (18 > int.parse(formattedTime)) {
      return const AssetImage('assets/images/day.jpg');
    } else {
      return const AssetImage('assets/images/night.jpg');
    }
  }

  static Image setIconForMain(String iconCode) {
    return Image.network('https://openweathermap.org/img/wn/$iconCode@2x.png');
  }
}
