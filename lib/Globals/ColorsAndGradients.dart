
import 'package:flutter/material.dart';

class Gradients{

  static const RadialGradient primary = RadialGradient(
    // colors: [Color.fromARGB(255, 228, 16, 87), Color.fromARGB(255, 255, 67, 67)],
    // colors: [Color.fromARGB(255, 60, 6, 255), Color.fromARGB(255, 111, 0, 255),],
    colors: [Colors.deepPurple, Colors.purple],
    center: Alignment(1,-1),
    radius: 1.5,
  );
  static RadialGradient tableTile = RadialGradient(
    colors: [const Color.fromRGBO(215, 215, 215, 1), Colors.white, Colors.grey.shade200],
    center: Alignment.topRight,
    radius: 1.5
  );
  static const LinearGradient linearFlowFAB = LinearGradient(
    colors: [Colors.deepPurple, Colors.purple],
    end: Alignment.topRight
  );
}

class Colors_{

  static const primaryBlue = Color.fromRGBO(20, 0, 255, 1);
  static const primaryPurple = Color.fromRGBO(100,0,255, 1);
}