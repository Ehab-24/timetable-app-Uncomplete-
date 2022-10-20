
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Classes/Reminder.dart';
import '../Databases/LocalDatabase.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';


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

    return  Slidable(

      endActionPane: ActionPane(

        motion: const DrawerMotion(),
        extentRatio: 0.3,
        children: [
          SlidableAction(
            onPressed: (conetext) async {
              await LocalDatabase.instance.deleteReminder(widget.reminder.id!);
              remReader.remove(widget.reminder);
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          ),
        ],
      ),

      startActionPane: ActionPane(

        motion: const DrawerMotion(),
        extentRatio: 0.35,

        children: [
          SlidableAction(
            onPressed: (conetext) async {
              //TODO:
            },
            backgroundColor: const Color.fromARGB(255, 37, 201, 16),
            foregroundColor: Colors.white,
            icon: Icons.download_done_rounded,
            label: 'Done',
          ),
        ],
      ),

      child: Container(

        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
        ),

        child: ListTile(
          
          tileColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Text(
                  widget.reminder.title,
                  style: TextStyles.b1,
                ),
                const Spacer(),
                Text(
                  DateFormat.yMEd().format(widget.reminder.dateTime),
                  style: TextStyles.b3,
                ),
              ],
            ),
          ),
          subtitle: Text(
            '${widget.reminder.description} wief wefuweouf weof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw fy feur oeru goerug eori gueorgweof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw fy feur oeru goerug eori gueorgweof oew fu sifu sfsuf sif sufosiuf yf iusy fiuys fiyw.',
            // style: TextStyles.b4(color: const Color.fromRGBO(55, 71, 79, 1)),
            style: TextStyles.b4(color: Colors.blueGrey.shade800),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
        ),
      ),
    );
  }
}