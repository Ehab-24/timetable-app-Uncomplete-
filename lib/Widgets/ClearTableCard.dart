import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Classes/TimeTable.dart';
import '../Globals/Decorations.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';
import '../Globals/Utils.dart';

class ClearTableCard extends StatefulWidget {
  const ClearTableCard({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  State<ClearTableCard> createState() => _ClearTableCardState();
}

class _ClearTableCardState extends State<ClearTableCard> {
  late final Table_pr tableReader;

  @override
  void initState() {
    tableReader = context.read<Table_pr>();
    super.initState();
  }

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
                    'All slots will be permanently deleted.',
                    style: TextStyles.b4(colorWatch.foreground),
                    textAlign: TextAlign.center,
                  ),
                  Spaces.vertical20,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Do you want to clear table:\n',
                        style: TextStyles.b2(colorWatch.foreground),
                      ),
                      TextSpan(
                        text: '"${widget.timeTable.title}"',
                        style: TextStyles.h2light(colorWatch.foreground),
                      )
                    ]),
                  ),
                  Spaces.vertical40,
                  ElevatedButton(
                      onPressed: _onPressed, child: const Text('Yes'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() {
    tableReader.clearTable(widget.timeTable.id!);
    LocalDatabase.instance.clearTimeTable(widget.timeTable.id!);

    Navigator.of(context).pop();

    Utils.showSnackBar(context, 'Cleared table: "${widget.timeTable.title}"', );
  }
}
