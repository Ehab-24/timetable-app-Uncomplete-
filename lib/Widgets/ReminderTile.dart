
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Widgets/Helpers.dart';

import '../Classes/Reminder.dart';
import '../Databases/LocalDatabase.dart';
import '../Databases/ServicesPref.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';
import '../Globals/enums.dart';
import 'EditReminderScreen.dart';


class ReminderTile extends StatefulWidget {
  const ReminderTile({
    Key? key,
    required this.reminder,
  }) : super(key: key);

  final Reminder reminder;

  @override
  State<ReminderTile> createState() => _ReminderTileState();
}

class _ReminderTileState extends State<ReminderTile> {

  late final Reminder_pr remReader;
  bool isPressed = false;

  @override
  void initState() {
    remReader = context.read<Reminder_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return PhysicalModel(

      color: Colors.transparent,
      shadowColor: colorWatch.shadow,
      elevation: ELEVATION,
      borderRadius: BorderRadius.circular(80),

      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: MARGIN,
          child: InkWell(
      
            onTap: (){
              Navigator.of(context).push(
                Utils.buildFadeThroughTransition(EditReminderScreen(reminder: widget.reminder,), colorWatch.background)
              );
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: colorWatch.splash,
            highlightColor: colorWatch.splash,
      
            child: Ink(
          
              decoration: Decorations.reminderTile(colorWatch.onBackground),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Center(
                    child: Text(
                      DateFormat('EEE, M-d-y').format(widget.reminder.dateTime),
                      style: TextStyles.bk4(Prefs.isDarkMode? Colors.white70: Colors.black38),
                    ),
                  ),
            
                  const HorzDividerMini(),
                  
                  Spaces.vertical10,
            
                  Text(
                    widget.reminder.title,
                    style: TextStyles.b1(colorWatch.foreground),
                  ),
                  Spaces.vertical20,
                  Text(
                    widget.reminder.description,
                    style: TextStyles.b4(colorWatch.foreground),
                  ),
                
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      
                      Text(
                        DateFormat('K : mm a').format(widget.reminder.dateTime),
                        style: TextStyles.toast(colorWatch.foreground.withOpacity(0.75), background: colorWatch.onBackground),
                      ),

                      const Spacer(),
                      
                      IconButton(
                        tooltip: 'Delete',
                        icon: Icon(Icons.delete_forever, color: colorWatch.foreground,),
                        onPressed: () async {
                          await LocalDatabase.instance.deleteReminder(widget.reminder.id!);
                          remReader.remove(widget.reminder);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}