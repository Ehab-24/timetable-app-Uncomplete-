
import 'package:flutter/material.dart';

class TextStyles{

  static const TextStyle b6 = TextStyle(
      color: Color.fromRGBO(69, 90, 100, 1),
      fontSize: 12,
      letterSpacing: 0.8,
      fontWeight: FontWeight.w600
    );
  static const b5 = TextStyle(
      fontSize: 16,
      fontStyle: FontStyle.italic,
      color: Color.fromRGBO(224, 224, 224, 1)
    );
  static TextStyle b4({Color color = const Color.fromRGBO(55, 71, 79, 1)}) => TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: FontWeight.w400
    );
  static b3({Color color = const Color.fromRGBO(55, 71, 79, 1)}) => TextStyle(
      color: color,
      fontSize: 18,
      letterSpacing: 1,
      wordSpacing: 2,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
    );
  static const TextStyle b1 = TextStyle(
      color: Color.fromRGBO(55, 71, 79, 1),
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
  static const TextStyle b0 = TextStyle(
    color: Colors.deepPurple,
    wordSpacing: 1.5,
    fontSize: 26,
    fontWeight: FontWeight.w500
  );

  static TextStyle h6(Color color) => TextStyle(
      color: color,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
  static const TextStyle h5 = TextStyle(
    color: Color.fromRGBO(224, 224, 224, 0.9),
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 1
  );
  static const TextStyle h4 = TextStyle(
      color: Color.fromRGBO(55, 71, 79, 1),
      fontSize: 16,
      letterSpacing: 0.8,
      fontWeight: FontWeight.bold
    );
  static const TextStyle h2 = TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8
    );
  static const TextStyle h1 = TextStyle(
      color: Color.fromRGBO(55, 71, 79, 1),
      fontSize: 28,
      fontWeight: FontWeight.w700
    );
  static TextStyle h0(double size, {Color color = const Color.fromRGBO(224, 224, 224, 1)}) => TextStyle(
    fontFamily: 'Coiny',
    fontSize: size,
    fontWeight: FontWeight.w400,
    color: color
  );
}

class ButtonStyles{

    static ButtonStyle closeButton(Color color) => OutlinedButton.styleFrom(
      side: BorderSide(color: color, width: 0.5)
    );
    static ButtonStyle okButton(Color color) => ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white
    );
}