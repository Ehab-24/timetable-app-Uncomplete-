
import 'package:flutter/material.dart';
import 'package:timetable_app/Globals/Styles.dart';

import 'ColorsAndGradients.dart';
import 'Utils.dart';

class Decorations{

  static const BoxDecoration firstTableScreen = BoxDecoration(
      gradient: RadialGradient(
        colors: [Color.fromARGB(255, 156, 27, 216), Color.fromRGBO(69, 39, 160, 1)],
        center: Alignment(0.85, 0.9),
        radius: 3
      )
    );
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
  static BoxDecoration decoratedContainer = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: Gradients.decoratedContainer
  );
  static BoxDecoration decoratedContainer_alt(Color color) => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: color,
  );
  static BoxDecoration progressIndicator = BoxDecoration(
    color: Colors.pink,
    borderRadius: BorderRadius.circular(500),
    boxShadow: const [               
      BoxShadow(
        color: Colors.black45,
        blurRadius: 10
      )
    ]
  );
  static BoxDecoration tableTile(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20)
  );
  static BoxDecoration tableTileExternal = BoxDecoration(
    borderRadius: BorderRadius.circular(8),
  );
  static BoxDecoration dropdownButton(Color color) => BoxDecoration(
    border: Border.all(
      color: color,
    ),
    borderRadius: BorderRadius.circular(6)
  );
  static BoxDecoration workLoadBar = BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color.fromRGBO(255, 101, 127, 1), Color.fromRGBO(255, 51, 112, 1)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
    ),
    borderRadius: BorderRadius.circular(12)
  );
  static BoxDecoration workLoadBar_alt = BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color.fromRGBO(255, 101, 127, 0.2), Color.fromRGBO(255, 51, 112, 0.2)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
    ),
    borderRadius: BorderRadius.circular(12)
  );
  static BoxDecoration timeTableScreenHeader(AssetImage image, double h, double w) => BoxDecoration(
            
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
      colors: [Colors.black87, Colors.black54],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
    )
  );
  static const BoxDecoration homeImage = BoxDecoration(
    image: DecorationImage(
      // image: AssetImage('assets/images/home_bk.jpg'),
      image: AssetImage('assets/images/landscape.jpg'),
      fit: BoxFit.cover,
    ),
  );
  static const BoxDecoration tablesScreenAppBar = BoxDecoration(
    gradient: Gradients.primary,
  );
  static BoxDecoration reminderHeader(final double w) => BoxDecoration(
    gradient: Gradients.primary,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.elliptical(w/3, 30), 
      bottomRight: Radius.elliptical(w/3, 30), 
    ),
    boxShadow: const [
      BoxShadow(
        blurRadius: 10,
        color: Colors.black54
      )
    ]
  );
  static BoxDecoration reminderTile(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(20),
  );
  static BoxDecoration FAB(Color color) => BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(0.5),
        blurRadius: 8,
        // offset: const Offset(1.5, 3)
      )
    ]
  );


  static InputDecoration textFormField(String label, Color color) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Utils.darken(color)
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
  );
  static InputDecoration textFieldBold({required String hint, EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24), 
    Color color = const Color.fromRGBO(238, 238, 238, 1), Color errorColor = Colors.red}) => 
  InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black26, fontWeight: FontWeight.w900),
    fillColor: color,
    filled: true,
    isDense: true,
    contentPadding: contentPadding,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(20),
    ),
    errorStyle: TextStyle(
      color: errorColor,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    )
  );
}