
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/FocusedMenuItem.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';

import '../Classes/TimeSlot.dart';
import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/Reals.dart';
import 'DayTile.dart';
import 'TimeSlotTile.dart';


class TimeTableWidget extends StatelessWidget {
  const TimeTableWidget({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
    
        backgroundColor: Colors.grey.shade200,
    
        body: TimeTablePageBody(timeTable: timeTable),

        floatingActionButton: _FAB(timeTable: timeTable),
      ),
    );
  }
}

/////////////////////////////////////~ ~ ~ Cutom FAB ~ ~ ~ /////////////////////////////////////////////////////

class _FAB extends StatelessWidget {
  const _FAB({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {

    final Day_pr dayWatch = context.watch<Day_pr>();
    final double h = Utils.screenWidthPercentage(context, 1);

    return Padding(
      padding: EdgeInsets.only(bottom: h * 1.265),
      child: FloatingActionButton(
        mini: true,
        onPressed: (){
          Utils.showEditDialog(context, TimeSlot.zero(timeTable.id!, dayWatch.selectedDay), color: Colors.pink, isfirst: true);
        },
        child: Icon(Icons.add, color: Colors.blueGrey.shade800,),
      ),
    );
  }
}

///////////////////////////////////////~ ~ ~ BODY ~ ~ ~ /////////////////////////////////////////////////

class TimeTablePageBody extends StatefulWidget {
  const TimeTablePageBody({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  State<TimeTablePageBody> createState() => _TimeTablePageBodyState();
}

class _TimeTablePageBodyState extends State<TimeTablePageBody> {

  late Day_pr dayReader;
  late final AssetImage headerImage;
  late final Timer timer;

  //A 100ms ticker to manage animations.
  int ticker = 0;

  @override
  void initState() {
    timer = Timer.periodic(Durations.d100, (timer) {setState((){ticker++;});});
    dayReader = context.read<Day_pr>();

    //TODO: make it pop up w/ opacity
    headerImage = const AssetImage('assets/images/blobs_bk2.png');
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Day_pr dayWatch = context.watch<Day_pr>();

    final int noOfDays = widget.timeTable.timeSlots[dayWatch.selectedDay].length;
    
    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);

    return Column(

      crossAxisAlignment: CrossAxisAlignment.end,

      children: [

        Container(
              
          width: double.infinity,
          height: h * 0.3,
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
              
          decoration: Decorations.timeTableWidgetHeader(headerImage, h, w),
      
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
              _Actions(timeTable: widget.timeTable),
            
              Text(
                widget.timeTable.title,
                style: TextStyles.h2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        //Time slot tiles AND days selector.
        Expanded(
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              //Week Days Selector.
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: days.map((day) => 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 6, 20),
                      child: DayTile(
                        day: day, width: w * 0.1, 
                        onDayChange: (){
                          dayReader.setDay(days.indexOf(day));
                          ticker = 0;
                        }))
                  ).toList()
                ),
              ),
        
              //Time Slot Tiles for currently selected day.
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const BouncingScrollPhysics(),
                  itemCount: noOfDays + 1,
                  itemBuilder: ((context, index) {

                    bool beginAnimation = ticker > index + 2;

                    return index == noOfDays  //The last index.
                    ? Spaces.vertical60
                    : AnimatedTimeSlotTile(
                      beginAnimation: beginAnimation, 
                      timeSlot: widget.timeTable.timeSlots[dayWatch.selectedDay][index],
                    );}
                  )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//ACTION Buttons:-
class _Actions extends StatefulWidget {
  const _Actions({
    Key? key,
    required this.timeTable
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  State<_Actions> createState() => _ActionsState();
}

class _ActionsState extends State<_Actions> {

  late final Day_pr dayReader;

  @override
  void initState() {
    dayReader = context.read<Day_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 8),
        child: Row(
      
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
      
          children: [
      
            IconButton(
              splashRadius: 24,
              onPressed: (){
                dayReader.setDay(DateTime.now().weekday - 1);
                Navigator.of(context).pop();
              }, 
              icon: const Icon(Icons.arrow_back, color: Colors.white,)
            ),
      
            Material(
              type: MaterialType.transparency,
              child: _FocusedMenuHolder(timeTable: widget.timeTable,),
            ),
          ],
        ),
      ),
    );
  }
}
//
class _FocusedMenuHolder extends StatelessWidget {
  const _FocusedMenuHolder({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {

    final Day_pr dayWatch = context.watch<Day_pr>();

    return FocusedMenuHolder(
        
      menuWidth: 170,
      menuOffset: 12,
      onPressed: (){},
      openWithTap: true,
        
      menuItems: [
        
        focusedMenuItem(
          onPressed: (){}, 
          item: focusedMenuItems[0],
        ),
        focusedMenuItem(
          onPressed: (){}, 
          item: focusedMenuItems[1],
        ),
        focusedMenuItem(
          onPressed: (){}, 
          item: focusedMenuItems[2],
        ),
        focusedMenuItem(
          onPressed: (){
            Utils.showDeleteTableDialog(context, timeTable);
          }, 
          item: focusedMenuItems[3],
        ),
        focusedMenuItem(
          onPressed: (){}, 
          item: focusedMenuItems[4],
        ),
        focusedMenuItem(
          onPressed: (){}, 
          item: focusedMenuItems[5],
        ),
        focusedMenuItem(
          onPressed: (){
            Utils.showEditDialog(context, TimeSlot.zero(timeTable.id!, dayWatch.selectedDay), color: Colors.pink, isfirst: true);
          }, 
          item: focusedMenuItems[6],
        ),
      ],
        
      child: const Icon(
        Icons.more_vert, 
        color: Colors.white, size: 30,
      )
    );
  }

  FocusedMenuItem focusedMenuItem({required VoidCallback onPressed, required FocusedMenuListItem item}) {
    return FocusedMenuItem(
      title: Text(item.title),
      trailingIcon: item.icon, 
      onPressed: onPressed,
    );
  }
}