
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Decorations.dart';

import '../Classes/Reminder.dart';
import '../Databases/LocalDatabase.dart';
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

  @override
  void initState() {
    remReader = context.read<Reminder_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final _createEditReminderScreen = PageRouteBuilder(
      pageBuilder: ((context, animation, secondaryAnimation) => 
        EditReminderScreen(reminder: widget.reminder)),
      transitionDuration: Durations.d400,
      transitionsBuilder: ((context, animation, secondaryAnimation, child) { 

        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero);
        final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutQuint);

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      })
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(

          onDoubleTap: (){},
          onTap: (){
            Navigator.of(context).push(
              _createEditReminderScreen
            );
          },

          child: Container(
            
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: Decorations.reminderTile,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18,12,24,8),
              child: Column(
        
                crossAxisAlignment: CrossAxisAlignment.start,
        
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      widget.reminder.title,
                      style: TextStyles.b1,
                    ),
                  ),
        //wief wefuweouf weof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw fy feur oeru goerug eori gueorgweof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw fy feur oeru goerug eori gueorgweof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw.'
                  Text(
                    widget.reminder.description,
                    style: TextStyles.b4(color: const Color.fromRGBO(55, 71, 79, 1)),
                  ),
        
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () async {
                        await LocalDatabase.instance.deleteReminder(widget.reminder.id!);
                        remReader.remove(widget.reminder);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

        Positioned(
          right: 16,
          top: -6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              DateFormat.yMEd().format(widget.reminder.dateTime),
              style: TextStyles.b3(color: Colors.white),
            ),
          ),
        )
      ],
    );
    // return  Slidable(

    //   endActionPane: ActionPane(

    //     motion: const DrawerMotion(),
    //     extentRatio: 0.3,
    //     children: [
    //       SlidableAction(
    //         onPressed: (conetext) async {
    //           await LocalDatabase.instance.deleteReminder(widget.reminder.id!);
    //           remReader.remove(widget.reminder);
    //         },
    //         backgroundColor: const Color(0xFFFE4A49),
    //         foregroundColor: Colors.white,
    //         icon: Icons.delete,
    //         label: 'Remove',
    //       ),
    //     ],
    //   ),

    //   startActionPane: ActionPane(

    //     motion: const DrawerMotion(),
    //     extentRatio: 0.35,

    //     children: [
    //       SlidableAction(
    //         onPressed: (conetext) async {
    //           //TODO:
    //         },
    //         backgroundColor: const Color.fromARGB(255, 37, 201, 16),
    //         foregroundColor: Colors.white,
    //         icon: Icons.download_done_rounded,
    //         label: 'Done',
    //       ),
    //     ],
    //   ),

    //   child: Container(

    //     clipBehavior: Clip.hardEdge,
    //     padding: const EdgeInsets.symmetric(vertical: 16),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(8)
    //     ),

    //     child: ListTile(
          
    //       tileColor: Colors.white,
    //       title: Padding(
    //         padding: const EdgeInsets.only(bottom: 16),
    //         child: Row(
    //           children: [
    //             Text(
    //               widget.reminder.title,
    //               style: TextStyles.b1,
    //             ),
    //             const Spacer(),
    //             Text(
    //               DateFormat.yMEd().format(widget.reminder.dateTime),
    //               style: TextStyles.b3,
    //             ),
    //           ],
    //         ),
    //       ),
    //       subtitle: Text(
    //         '${widget.reminder.description} wief wefuweouf weof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw fy feur oeru goerug eori gueorgweof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw fy feur oeru goerug eori gueorgweof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw.',
    //         // style: TextStyles.b4(color: const Color.fromRGBO(55, 71, 79, 1)),
    //         style: TextStyles.b4(color: Colors.blueGrey.shade800),
    //       ),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(8)
    //       ),
    //     ),
    //   ),
    // );
  }
}