
import 'package:flutter/material.dart';

import 'ColorsAndGradients.dart';

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
          
    gradient: Gradients.tableTile,
    borderRadius: BorderRadius.circular(24)
  );
  static BoxDecoration tableTileExternal = BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    boxShadow: const [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(5,5),
        blurRadius: 10,
      ),
    ],
  );
  static BoxDecoration workLoadBar = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.green.shade300, Colors.green],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
    ),
    borderRadius: BorderRadius.circular(12)
  );
}