
import 'package:flutter/material.dart';

class TextStyles{

  static const TextStyle body4 = TextStyle(
      color: Color.fromRGBO(55, 71, 79, 1),
      fontSize: 14,
      fontWeight: FontWeight.w400
    );
  static const TextStyle body1 = TextStyle(
      color: Color.fromRGBO(55, 71, 79, 1),
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
  static const TextStyle timeTableTitle = TextStyle(
    color: Colors.cyan,
    fontWeight: FontWeight.w300,
    fontSize: 24,
    overflow: TextOverflow.ellipsis,
    shadows: [
      Shadow(
        color: Colors.cyanAccent,
        blurRadius: 10
      ),
    ],
  );
}