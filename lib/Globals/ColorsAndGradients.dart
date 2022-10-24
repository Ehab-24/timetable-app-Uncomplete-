
import 'package:flutter/material.dart';

class Gradients{

  static const RadialGradient primary = RadialGradient(
    colors: [Colors.purple, Colors.pink],
    center: Alignment(1,-1),
    radius: 1.5,
  );
  static RadialGradient tableTile = RadialGradient(
    colors: [const Color.fromRGBO(215, 215, 215, 1), Colors.white, Colors.grey.shade200],
    center: Alignment.topRight,
    radius: 1.5
  );
  static const LinearGradient linearFlowFAB = LinearGradient(
    colors: [Colors.pink, Color.fromARGB(255, 233, 30, 148)],
    begin: Alignment.bottomLeft,
    end: Alignment.center
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
  static const LinearGradient linearFlowFAB_alt = LinearGradient(
    colors: [Colors.white, Color.fromRGBO(224, 224, 224, 1)],
    begin: Alignment.center,
    end: Alignment.bottomLeft
  );
}