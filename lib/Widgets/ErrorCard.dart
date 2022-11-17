
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import '../Globals/Providers.dart';
import '../Globals/Utils.dart';
import '../Globals/enums.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard({
    Key? key,
    required this.content,
  }) : super(key: key);

  final String content;
  
  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return Dialog(

      backgroundColor: Colors.transparent,

      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Utils.screenWidthPercentage(context, 0.04)),          
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: Decorations.decoratedContainer_alt(colorWatch.onBackground),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children:[

            Column(      
              children: [

                Text(
                  'Error!',
                  style: TextStyles.h1(colorWatch.foreground),
                  textAlign: TextAlign.center,
                ),

                Spaces.vertical20,
              
                Text(
                  content,
                  style: TextStyles.b4(colorWatch.foreground),
                  textAlign: TextAlign.center,
                ),

                Spaces.vertical40,
            
                ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}