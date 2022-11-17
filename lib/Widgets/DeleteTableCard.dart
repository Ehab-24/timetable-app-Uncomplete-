import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/Reals.dart';
import '../Globals/Styles.dart';
import '../Globals/Utils.dart';

class DeleteTableCard extends StatelessWidget {
  const DeleteTableCard({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

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
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(
                Icons.close,
                size: 28,
                color: colorWatch.foreground,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Text(
                    'Item will be deleted\npermanently.',
                    style: TextStyles.b4(colorWatch.foreground),
                    textAlign: TextAlign.center,
                  ),
                  Spaces.vertical20,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Do you want to delete table: ',
                        style: TextStyles.b2(colorWatch.foreground),
                      ),
                      TextSpan(
                        text: '"${timeTable.title}"',
                        style: TextStyles.h2light(colorWatch.foreground),
                      )
                    ]),
                  ),
                  Spaces.vertical40,
                  _DeleteButton(timeTable: timeTable)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _DeleteButton extends StatefulWidget {
  const _DeleteButton({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  late final Table_pr tableReader;

  @override
  void initState() {
    tableReader = context.read<Table_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (tableReader.tables.length == 1) {
          Navigator.of(context).pop();
          Utils.showErrorDialog(context, 'You must have atleast one table.');
          return;
        }

        if (Prefs.homeTable >= currentTableIndex) {
          Prefs.setHomeTable(Prefs.homeTable - 1);
        }

        tableReader.removeTable(widget.timeTable.id!);
        LocalDatabase.instance.deleteTimeTable(widget.timeTable.id!);

        Navigator.of(context).pop();

        Utils.showSnackBar(
          context, 
          'Deleted table: "${widget.timeTable.title}"',
        );
      },
      child: const Text(
        'Yes',
      ),
    );
  }
}
