
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';

import '../Classes/TimeSlot.dart';
import '../Globals/Utils.dart';
import '../Globals/enums.dart';


class TimeSlotTile extends StatelessWidget {
  TimeSlotTile({
    Key? key,
    required this.timeSlot,
    required this.color,
  }) : super(key: key);

  final TimeSlot timeSlot;
  final Color color;

  final GlobalKey<FormState>formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Column(

      crossAxisAlignment: CrossAxisAlignment.end,

      children: [

        Material(

          elevation: 10,
          shadowColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomRight: Radius.circular(10)
            )
          ),

          clipBehavior: Clip.hardEdge,

          child: ListTile(

            onTap: (){
              Utils.showEditDialog(context, timeSlot, color: color);
            },
            onLongPress: (){
              Utils.showDeleteDialog(context, timeSlot);
            },
          
            title: Text(
              timeSlot.title,
              style: TextStyles.h6(Utils.darken(color)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          
            subtitle: Text(
              '${timeSlot.subtitle}iafu ef oeufeyf ieuyf iuyewf e fiuyef weyf iwe fyw efy wieuf yi ef',
              style: TextStyles.b6,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            leading: Container(
              width: 6,
              color: color,
            ),
          
            trailing: Text(
              timeSlot.venue,
              style: TextStyles.h4,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          
            tileColor: Colors.white,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            contentPadding: const EdgeInsets.only(right: 26),
          ),
        ),

        Container(

          height: 28,
          width: 108,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 12),

          decoration: Decorations.timeSlotTileFooter(Utils.darken(color, 0.05)),

          child: Text(
            '${timeSlot.startTime.hour}:${timeSlot.startTime.minute} - ${timeSlot.endTime.hour}:${timeSlot.endTime.minute}',
            style: const TextStyle(
              // color: Color.fromRGBO(55, 71, 79, 1),
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14
            ),
          ),
        )
      ],
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

class AnimatedTimeSlotTile extends StatelessWidget {
  const AnimatedTimeSlotTile({
    Key? key,
    required this.beginAnimation,
    required this.timeSlot,
    required this.color
  }) : super(key: key);

  final bool beginAnimation;
  final TimeSlot timeSlot;
  final Color color;

  @override
  Widget build(BuildContext context) {

    final double h = Utils.screenHeightPercentage(context,1);
    final double w = Utils.screenWidthPercentage(context,1);

    return AnimatedPadding(

      duration: Durations.d300,
      curve: Curves.decelerate,

      padding: EdgeInsets.only(
        left: beginAnimation
        ? w * 0.2: w * 0.15,
        right: beginAnimation
        ? w * 0.1: w * 0.15,
        top: h * 0.05
      ),

      child: AnimatedOpacity(
      
        duration: beginAnimation
        ? Durations.d300
        : const Duration(seconds: 0),
      
        curve: Curves.easeInOut,
        opacity: beginAnimation? 1: 0,
      
        child: TimeSlotTile(
          timeSlot: timeSlot, 
          color: color,
        ),
      ),
    );
  }
}