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
    final Color_pr colorWatch = context.watch<Color_pr>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Utils.screenWidthPercentage(context, 0.04)),
        decoration: Decorations.decoratedContainer_alt(colorWatch.onBackground),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon:
                    Icon(Icons.close, size: 28, color: colorWatch.foreground)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Text(
                    'Item will be deleted permanently.',
                    style: TextStyles.b4(colorWatch.foreground),
                    textAlign: TextAlign.center,
                  ),
                  Spaces.vertical20,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Do you want to delete slot: ',
                        style: TextStyles.b2(colorWatch.foreground),
                      ),
                      TextSpan(
                        text: '"${timeSlot.title}"?',
                        style: TextStyles.h2light(colorWatch.foreground),
                      )
                    ]),
                  ),
                  Spaces.vertical40,
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<Table_pr>(context, listen: false)
                          .removeSlot(timeSlot);
                      Navigator.of(context).pop();
                      Utils.showSnackBar(
                        context,
                        'Slot deleted',
                      );
                    },
                    child: const Text(
                      'Yes',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
