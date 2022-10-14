
import 'package:flutter/material.dart';

class TextStyles{

  static TextStyle b4({Color color = const Color.fromRGBO(55, 71, 79, 1)}) => TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: FontWeight.w400
    );
  static const b3 = TextStyle(
    color: Color.fromRGBO(55, 71, 79, 1),
    fontSize: 18,
    letterSpacing: 1.2,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w400,
  );
  static const TextStyle b1 = TextStyle(
      color: Color.fromRGBO(55, 71, 79, 1),
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
  static const TextStyle h2 = TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8
    );
  static const TextStyle h1 = TextStyle(
      color: Color.fromRGBO(84, 110, 122, 1),
      fontSize: 28,
      fontWeight: FontWeight.w700
    );
}

class ButtonStyles{

    static ButtonStyle closeButton = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6)
      ),
    );
}