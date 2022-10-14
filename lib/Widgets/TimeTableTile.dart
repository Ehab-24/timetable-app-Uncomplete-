
import 'package:flutter/material.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/TimeTableWidget.dart';

import '../Classes/TimeTable.dart';

class TimeTableTile extends StatelessWidget{
  const TimeTableTile({
    Key? key,
    required this.table
  }) : super(key: key);

  final TimeTable table;
  final AssetImage tablePageHeaderImage = const AssetImage('assets/images/blobs_bk2.png');

  @override
  Widget build(BuildContext context) {

    final double w = Utils.screenWidthPercentage(context, 1);

    return Container(

      decoration: Decorations.tableTileExternal,

      child: Material(
        
        type: MaterialType.transparency,
        
        child: InkWell(
      
          borderRadius: BorderRadius.circular(24),
          onLongPress: (){
            Utils.showDeleteTableDialog(context, table);
          },
          onDoubleTap: (){},
          onTap: (){
            currentTableId = table.id!;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => 
                  TimeTableWidget(timeTable: table, headerImage: tablePageHeaderImage,),
              )
            );
          },
      
          child: Ink(
        
            width: w * 0.9,
            decoration: Decorations.tableTileInternal,
        
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    bottom: 12,
                  ),
                  child: Column(
      
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
      
                      Text(
                        table.title,
                        style: const TextStyle(
                          color: Colors.pink,
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),
                      ),
      
                      Spaces.vertical20,
      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _WorkLoadBarHeaders(),

                          Spaces.horizontal20,
                          
                          _WorkLoadBars(table: table)
                      ],)
                    ],
                  ),
                ),
        
                Container(
                  width: 8,
                  //TODO: provide color.
                  color: Colors.pink,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkLoadBars extends StatelessWidget{
  const _WorkLoadBars({
    Key? key,
    required this.table,
  }) : super(key: key);

  final TimeTable table;

  @override
  Widget build(BuildContext context) {

    final double w = Utils.screenWidthPercentage(context, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(7, (index) => 
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: buildWorkLoadBar(w, table.dayLoad(index)),
      )
    )
    );
  }

  Widget buildWorkLoadBar(double w, double hours) {
    
    return Row(
      children: [
        Container(
          width: w * 0.7 * hours / 12 + 16,
          height: 16,
          decoration: Decorations.workLoadBar
        ),
        Spaces.horizontal10,
        Text(
          hours.toStringAsFixed(2),
          // style: TextSTyle,
        )
      ],
    );
  }
}

class _WorkLoadBarHeaders extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    
    return Column(

      children: List<Widget>.generate(7, (index) => 
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.5),
          child: Text(
            days[index].substring(0,1),
            style: const TextStyle(

              //TODO: supplied by main theme
              color: Color.fromRGBO(55, 71, 79, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      )
    );
  }
}