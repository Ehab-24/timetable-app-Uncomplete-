
// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

    return Row(
      children: [

        Text(
          '${timeSlot.span.toString()} hr',
          style: TextStyles.b4(colorWatch.foreground.withOpacity(0.5)),
        ),
        
        Spaces.horizontal(4),

        Container(height: 2, width: 20, color: colorWatch.foreground.withOpacity(0.5)),

        Spaces.horizontal(4),

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

    return PhysicalModel(
    
      color: Colors.transparent,
      shadowColor: colorWatch.shadow,
      elevation: ELEVATION,
      borderRadius: BORDER_RADIUS,
    
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
                children: [
                  Text(
                    timeSlot.title,
                    style: TextStyles.h2light(colorWatch.foreground),
                  ),
                  Text(
                    timeSlot.subtitle,
                    style: TextStyles.b4(colorWatch.foreground),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
          
              const Spacer(),
          
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: const BoxDecoration(gradient: Gradients.primary),
                
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: timeSlot.startTime.format(context),
                        style: TextStyles.bk4(colorWatch.background),
                      ),
                      TextSpan(
                        text: '\n\nto\n\n',
                        style: TextStyles.h8(colorWatch.background)
                      ),
                      TextSpan(
                        text: timeSlot.endTime.format(context),
                        style: TextStyles.bk4(colorWatch.background),
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

//////////////////////////////////////////////////////////////////////////////////////////////////


// class TimeSlotTile extends StatelessWidget {
//   TimeSlotTile({
//     Key? key,
//     required this.timeSlot,
//     required this.color,
//   }) : super(key: key);

//   final TimeSlot timeSlot;
//   final Color color;

//   final GlobalKey<FormState>formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
    
//     return Column(

//       crossAxisAlignment: CrossAxisAlignment.end,

//       children: [

//         Material(

//           elevation: 10,
//           shadowColor: Colors.black,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16),
//               bottomRight: Radius.circular(10)
//             )
//           ),

//           clipBehavior: Clip.hardEdge,

//           child: ListTile(


          
//             title: Text(
//               timeSlot.title,
//               style: TextStyles.h6(Utils.darken(color)),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
          
//             subtitle: Text(
//               '${timeSlot.subtitle}iafu ef oeufeyf ieuyf iuyewf e fiuyef weyf iwe fyw efy wieuf yi ef',
//               style: TextStyles.b6,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),

//             leading: Container(
//               width: 6,
//               color: color,
//             ),
          
//             trailing: Text(
//               timeSlot.venue,
//               style: TextStyles.b6,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
          
//             tileColor: Colors.white,
//             minLeadingWidth: 0,
//             minVerticalPadding: 0,
//             contentPadding: const EdgeInsets.only(right: 26),
//           ),
//         ),

//         Container(

//           height: 28,
//           width: 108,
//           alignment: Alignment.center,
//           margin: const EdgeInsets.only(right: 12),

//           decoration: Decorations.timeSlotTileFooter(Utils.darken(color, 0.05)),

//           child: Text(
//             '${timeSlot.startTime.format(context)} - ${timeSlot.endTime.format(context)}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//               fontSize: 14
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }