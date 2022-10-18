
import 'package:flutter/material.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
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
    final double h = Utils.screenHeightPercentage(context, 1);

    return Stack(

      clipBehavior: Clip.none,

      children: [

        Container(
        
          margin: EdgeInsets.only(top: h * 0.058),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              // BoxShadow(
              //   color: Colors.black38,
              //   offset: Offset(5,5),
              //   blurRadius: 10,
              // )
            ]
          ),
          child: _WorkLoadBarHeaders()
        ),

        Positioned(

          right: 0,

          child: Container(
        
            decoration: Decorations.tableTileExternal,
        
            child: Material(
              
              type: MaterialType.transparency,
              
              child: InkWell(
            
                borderRadius: BorderRadius.circular(8),
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
              
                  width: w * 0.8,
                  decoration: Decorations.tableTileInternal,
              
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      bottom: 20,
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
        
                        _WorkLoadBars(table: table)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
      children: List<Widget>.generate(7, (index) {

        double maxLoad = table.maxLoad;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: buildWorkLoadBar(w, table.dayLoad(index), maxLoad),
        );
      }
    )
    );
  }

  Widget buildWorkLoadBar(double w, double hours, double maxLoad) {
    
    return Row(
      children: [
        Container(
          width: w * 0.58 * hours / maxLoad + 16,
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
    
    final double h = Utils.screenHeightPercentage(context, 1);
  print(h);
    return Column(

      children: List<Widget>.generate(7, (index) => 
        Padding(
          padding: EdgeInsets.only(top: h * 0.015),
          child: Text(
            days[index].substring(0,1),
            style: const TextStyle(

              //TODO: supplied by main theme
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      )
    );
  }
}