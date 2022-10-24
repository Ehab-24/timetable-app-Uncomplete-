
import 'package:flutter/material.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import '../Globals/Utils.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    required this.content,
  }) : super(key: key);

  final String content;

  final _circularIndicator = const Positioned(
    top: -30,
    child: CircleAvatar(
      foregroundColor: Color.fromRGBO(238, 238, 238, 1),
      backgroundColor: Color.fromARGB(255, 218, 8, 71),
      radius: 30,
      child: Icon(Icons.nearby_error, size: 30,),
    ),
  );

  
  @override
  Widget build(BuildContext context) {
    return Dialog(

      backgroundColor: Colors.transparent,

      child: Stack(

        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,

        children: [

          Container(
            margin: EdgeInsets.symmetric(horizontal: Utils.screenWidthPercentage(context, 0.04)),
            
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
          
            decoration: Decorations.popUpCard,
            
            child: Column(
          
              mainAxisSize: MainAxisSize.min,

              children: [

                const SizedBox(height: 40,),

                const Center(
                  child: Text(
                    'Error!',
                    style: TextStyles.h1
                  ),
                ),

                const SizedBox(height: 20,),

                Text(
                  content,
                  style: TextStyles.b4(color: Colors.blueGrey.shade800),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),
                
                Align(
                  alignment: Alignment.centerRight,
                  
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyles.closeButton(Colors.blueGrey.shade800),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Color.fromRGBO(55, 71, 79, 1)),
                    ),
                  ),
                )
              ],
            ),
          ),
          
          //Circular Indicator
          _circularIndicator
        ],
      ),
    );
  }
}