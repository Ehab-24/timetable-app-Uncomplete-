
import 'package:flutter/material.dart';

import 'ColorsAndGradients.dart';
import 'Utils.dart';

class Decorations{

  static BoxDecoration popUpCard = BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8),
    );
  static const InputDecoration titleTextField = InputDecoration(
      labelText: 'Title',
      labelStyle: TextStyle(
        color: Colors.cyan
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
    );
  static BoxDecoration timeTableWidget(bool isSelected) => BoxDecoration(
    
      borderRadius: BorderRadius.circular(30),
      
      gradient: isSelected
      ? const LinearGradient(
        colors: [Color.fromRGBO(55, 71, 79, 1), Color.fromARGB(255, 35, 45, 49)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
      )
      : LinearGradient(
        colors: [Colors.blueGrey.shade700, Colors.blueGrey.shade700]
      ),

      boxShadow: isSelected
      ? const [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black87
        )
      ] : []
    );
  static BoxDecoration tableTileInternal = BoxDecoration(
          
    // gradient: Gradients.tableTile,
    color: Colors.white,
    borderRadius: BorderRadius.circular(8)
  );
  static BoxDecoration tableTileExternal = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    boxShadow: const [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(5,5),
        blurRadius: 10,
      ),
    ],
  );
  static BoxDecoration dropdownButton(Color color) => BoxDecoration(
    border: Border.all(
      color: color,
    ),
    borderRadius: BorderRadius.circular(6)
  );
  static BoxDecoration workLoadBar = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.green.shade300, Colors.green],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
    ),
    borderRadius: BorderRadius.circular(12)
  );
  static BoxDecoration timeTableWidgetHeader(AssetImage image, double h, double w) => BoxDecoration(
            
    borderRadius: BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomRight: Radius.elliptical(w / 3, h / 10),
    ),
    image: DecorationImage(
      image: image,
      fit: BoxFit.cover
    ),
  );
  static BoxDecoration timeSlotTileFooter(Color color) => BoxDecoration(
    color: color,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    )
  );
  static const BoxDecoration homeVignette = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.transparent, Colors.black87],
      begin: Alignment.center,
      end: Alignment.bottomCenter
    )
  );
  static const BoxDecoration homeImage = BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/home_bk.jpg'),
      fit: BoxFit.cover
    ),
  );
  static InputDecoration textFormField(String label, Color color) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Utils.darken(color)
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
  );
}