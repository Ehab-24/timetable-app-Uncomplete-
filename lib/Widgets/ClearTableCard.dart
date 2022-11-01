
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/Styles.dart';
import '../Globals/Utils.dart';

class ClearTableCard extends StatelessWidget {
  const ClearTableCard({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {
    
    final Color_pr colorWatch = context.watch<Color_pr>();

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            
            child: Column(
          
              mainAxisSize: MainAxisSize.min,
          
              children: [

                Spaces.vertical40,

                Text(
                  'All slots will be permanently removed.',
                  style: TextStyles.b4(colorWatch.foreground),
                  textAlign: TextAlign.center,
                ),

                Spaces.vertical20,
              
                Text(
                  'Do you want to clear table: "${timeTable.title}"?',
                  style: TextStyles.b1(colorWatch.foreground),
                  textAlign: TextAlign.center,
                ),

                Spaces.vertical40,
            
                _Actions(timeTable: timeTable)
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

class _Actions extends StatefulWidget {
  const _Actions({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  State<_Actions> createState() => _ActionsState();
}

class _ActionsState extends State<_Actions> {

  late final Table_pr tableReader;

  @override
  void initState() {
    tableReader = context.read<Table_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'No',
          ),
        ),

        Spaces.horizontal40,

        ElevatedButton(
          onPressed: () {

            tableReader.clearTable(widget.timeTable.id!);
            LocalDatabase.instance.clearTimeTable(widget.timeTable.id!);

            Navigator.of(context).pop();
            
            Utils.showSnackBar(context, 'Cleared table: "${widget.timeTable.title}"', seconds: 2);
          }, 
          child: const Text(
            'Yes',
          ),
        ),        
      ],
    );
  }
}