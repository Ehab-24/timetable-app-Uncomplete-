
// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Providers.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Classes/TimeSlot.dart';
import '../Globals/Utils.dart';
import 'TimeSlotScreen.dart';


class TimeSlotTile extends StatelessWidget {
  const TimeSlotTile({
    Key? key,
    required this.timeSlot,
    required this.color
  }) : super(key: key);

  final TimeSlot timeSlot;
  final Color color;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final w = Utils.screenWidthPercentage(context, 1);

    return Row(
      children: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${timeSlot.span.toStringAsFixed(1)} hr',
              style: TextStyles.b4(colorWatch.foreground.withOpacity(0.5)),
            ),
            Spaces.vertical(4),

            Container(
              height: 2, 
              width: w * 0.16, 
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorWatch.foreground.withOpacity(0.5), Colors.transparent],
                  begin: const Alignment(-0.25, 0)
                )
              ),
            ),
          ],
        ),

        Expanded(
          child: _MainTile(timeSlot: timeSlot)
        ),
      ],
    );
  }
}

class _MainTile extends StatelessWidget {
  const _MainTile({
    Key? key,
    required this.timeSlot,
  }) : super(key: key);

  final TimeSlot timeSlot;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final w = Utils.screenWidthPercentage(context, 1);

    return PhysicalModel(
    
      color: Colors.transparent,
      shadowColor: colorWatch.shadow,
      elevation: ELEVATION,
      borderRadius: BorderRadius.circular(60),
    
      child: Material(
        type: MaterialType.transparency,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
      
          borderRadius: BorderRadius.circular(8),
          splashColor: colorWatch.splash,
          highlightColor: colorWatch.splash,
      
          onTap: (){
            Navigator.of(context).push(
              Utils.buildFadeThroughTransition( 
                TimeSlotScreen(timeSlot: timeSlot, isfirst: false, color: Colors.pink),
                colorWatch.background
              )
            );
          },
          onLongPress: (){
            Utils.showDeleteDialog(context, timeSlot);
          },
        
          child: Ink(
            padding: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorWatch.onBackground
            ),
        
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeSlot.title,
                      style: TextStyles.h2light(colorWatch.foreground),
                      overflow: TextOverflow.ellipsis,
                    ),
              
                    Spaces.vertical10, 
                    
                    SizedBox(
                      width: w * 0.5,
                      child: Text(
                        timeSlot.subtitle,
                        style: TextStyles.b4(colorWatch.foreground.withOpacity(0.75)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
            
                const Spacer(),
            
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: Prefs.isDarkMode? Gradients.decoratedContainer: Gradients.primary
                  ),
                  
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: timeSlot.startTime.format(context),
                          style: TextStyles.bUltra(colorWatch.background),
                        ),
                        TextSpan(
                          text: '\n\nto\n\n',
                          style: TextStyles.h8(colorWatch.background)
                        ),
                        TextSpan(
                          text: timeSlot.endTime.format(context),
                          style: TextStyles.bUltra(colorWatch.background),
                        ),
                      ]
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}