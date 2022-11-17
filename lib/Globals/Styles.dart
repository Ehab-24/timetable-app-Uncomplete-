
import 'package:flutter/material.dart';

class TextStyles{

  static const TextStyle b6 = TextStyle(
      color: Color.fromRGBO(69, 90, 100, 1),
      fontSize: 12,
      letterSpacing: 0.8,
      fontWeight: FontWeight.w600
    );
  static b5(Color color) => TextStyle(
      fontSize: 16,
      fontStyle: FontStyle.italic,
      color: color
    );
  static TextStyle b4(Color color) => TextStyle(
      color: color,
      fontSize: 14,
      letterSpacing: 1.0,
      wordSpacing: 1.5,
      fontWeight: FontWeight.w500
    );
  static b3(Color color) => TextStyle(
      color: color,
      fontSize: 18,
      letterSpacing: 1,
      wordSpacing: 2,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
    );
  static TextStyle b2(Color color) => TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontSize: 18,
  );
  static TextStyle b1(Color color) => TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
  static const TextStyle b0 = TextStyle(
    color: Colors.deepPurple,
    wordSpacing: 1.5,
    fontSize: 26,
    fontWeight: FontWeight.w500
  );
  static TextStyle bUltra(Color color) =>  TextStyle(
    color: color,
    fontFamily: 'Ultra',
    fontSize: 12,
    letterSpacing: 1
  );
  static TextStyle toast(Color color, {Color background = Colors.white}) => TextStyle(
    fontFamily: 'Ultra',
    fontSize: 12,
    color: color,
    background: Paint()
    ..color = background
    ..strokeWidth = 18
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
  );

  static TextStyle h8(Color color) => TextStyle(
    color: color,
    fontFamily: 'VarelaRound',
    fontWeight: FontWeight.w900,
    fontSize: 12,
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
  static TextStyle h4(Color color) => TextStyle(
      color: color,
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
  static TextStyle h1(Color color) => TextStyle(
      color: color,
      fontSize: 28,
      fontWeight: FontWeight.w700
    );
  static TextStyle h2light(Color color) => TextStyle(
    fontFamily: 'VarelaRound',
    fontSize: 20,
    fontWeight: FontWeight.w100,
    letterSpacing: 1.5,
    color: color
  );
  static TextStyle h1light(Color color) => TextStyle(
    fontFamily: 'VarelaRound',
    fontSize: 28,
    fontWeight: FontWeight.w100,
    letterSpacing: 1.5,
    color: color
  );
  static TextStyle h0(double size, {Color color = const Color.fromRGBO(224, 224, 224, 1)}) => TextStyle(
    fontFamily: 'Coiny',
    fontSize: size,
    fontWeight: FontWeight.w400,
    color: color
  );

  static TextStyle bk4(Color color) => TextStyle(
    fontFamily: 'Ultra',
    fontSize: 16,
    letterSpacing: 1.5,
    color: color
  );
  static TextStyle bk2({Color color = Colors.black12}) => TextStyle(
    fontFamily: 'Ultra',
    fontSize: 24,
    letterSpacing: 1.5,
    color: color
  );
}

class ButtonStyles{

    // static ButtonStyle closeButton(Color color) => OutlinedButton.styleFrom(
      
    // );
    static ButtonStyle okButton(Color color) => ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white
    );
}