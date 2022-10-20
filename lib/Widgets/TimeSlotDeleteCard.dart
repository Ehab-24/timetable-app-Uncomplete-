
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Classes/TimeSlot.dart';
import '../Globals/Providers.dart';
import '../Globals/Utils.dart';


class TimeSlotDeleteCard extends StatelessWidget {
  const TimeSlotDeleteCard({
    Key? key,
    required this.timeSlot,
  }) : super(key: key);

  final TimeSlot timeSlot;

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
          
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            
            child: Column(
          
              mainAxisSize: MainAxisSize.min,
          
              children: [

                const SizedBox(height: 40,),

                const Text(
                  'Item will be deleted permnently',
                  style: TextStyle(
                    color: Color.fromRGBO(55, 71, 79, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20,),
              
                const Text(
                  'Do you want to delete this slot?',
                  style: TextStyle(
                    color: Color.fromRGBO(55, 71, 79, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40,),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyles.closeButton(Colors.blueGrey.shade800), 
                      child: const Text(
                        'No',
                      ),
                    ),

                    Spaces.horizontal40,

                    ElevatedButton(
                      onPressed: () {
                        Provider.of<Table_pr>(context,listen: false).removeSlot(timeSlot);
                        Navigator.of(context).pop();
                        Utils.showSnackBar(context, 'Slot deleted', seconds: 2);
                      }, 
                      child: const Text(
                        'Yes',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          
          //Circular Indicator
          const Positioned(
            top: -30,
            child: CircleAvatar(
              foregroundColor: Color.fromRGBO(238, 238, 238, 1),
              backgroundColor: Color.fromRGBO(66, 66, 66, 1),
              radius: 30,
              child: Icon(Icons.delete, size: 30,),
            ),
          )
        ],
      ),
    );
  }
}