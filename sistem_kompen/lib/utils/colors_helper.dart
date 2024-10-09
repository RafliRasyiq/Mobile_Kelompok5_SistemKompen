import 'package:flutter/material.dart';

class ColorsHelper {
  static Color white({double opacity = 1}) =>
      Color.fromRGBO(255, 255, 255, opacity);
  static Color black({double opacity = 1}) => Color.fromRGBO(0, 0, 0, opacity);
  static Color lightGrey({double opacity = 1}) =>
      Color.fromRGBO(245, 245, 245, opacity);
  static Color darkGrey({double opacity = 1}) =>
      Color.fromRGBO(150, 150, 150, opacity);
}
