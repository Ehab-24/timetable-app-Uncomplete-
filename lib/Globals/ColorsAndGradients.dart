
import 'package:flutter/material.dart';

class Gradients{

  static const RadialGradient primary = RadialGradient(
    colors: [Color.fromARGB(255, 194, 18, 135), Colors.pink],
    center: Alignment(1,-1),
    radius: 3,
  );
  static RadialGradient tableTile = RadialGradient(
    colors: [const Color.fromRGBO(215, 215, 215, 1), Colors.white, Colors.grey.shade200],
    center: Alignment.topRight,
    radius: 1.5
  );
  static RadialGradient reminderHeaderForeground = RadialGradient(
    colors: [Colors.amber.shade300, Colors.yellow.shade900],
    radius: 4,
    focal: Alignment.center,
    focalRadius: 0.4
  );
  static RadialGradient backgroundBlob(AlignmentGeometry center) => RadialGradient(
    colors: [Colors.white.withOpacity(0.1), Colors.transparent],
    center: center,
    radius: 2
  );
  static const RadialGradient decoratedContainer = RadialGradient(
    colors: [Color.fromARGB(255, 255, 67, 161), Color.fromARGB(255, 255, 62, 94)],
    center: Alignment(1,-1),
    radius: 3,
  );
  static const LinearGradient linearFlowFAB = LinearGradient(
    colors: [Color.fromARGB(255, 233, 30, 148), Colors.pink],
    begin: Alignment.bottomLeft,
    end: Alignment.center
  );
  static const LinearGradient linearFlowFAB_alt = LinearGradient(
    colors: [Colors.white, Color.fromRGBO(224, 224, 224, 1)],
    begin: Alignment.center,
    end: Alignment.bottomLeft
  );
}

const splashC = Color.fromRGBO(166, 58, 255, 0.05);
const splashDarkC = Color.fromRGBO(255, 230, 0, 0.05);

const onBackgroundC = Colors.white;
const backgroundC = Color.fromRGBO(238, 238, 238, 1);
const foregroundC = Color.fromRGBO(55, 71, 79, 1);
const shadowC = Color.fromRGBO(233, 30, 99, 0.5);
const shadow_altC = Color.fromRGBO(144, 164, 174, 1);

const onBackgroundDarkC = Color.fromARGB(255, 6, 47, 80);
const backgroundDarkC = Color.fromARGB(255, 0, 28, 51);
const foregroundDarkC = Color.fromRGBO(238, 238, 238, 1);
const shadowDarkC = Colors.pink;
const shadow_altDarkC = Colors.white70;