
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/FocusedMenuItem.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Screens/Schedule/ScheduleScreen.dart';

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

    final double w = Utils.screenWidthPercentage(context, 1);
    final double h = Utils.screenHeightPercentage(context, 1);
    final Day_pr dayWatch = context.watch<Day_pr>();

    return SafeArea(
      child: Scaffold(
    
        backgroundColor: Colors.grey.shade200,
    
        body: TimeTablePageBody(w: w, h: h, timeTable: timeTable),

        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: h * 0.6),
          child: FloatingActionButton(
            mini: true,
            onPressed: (){
              Utils.showEditDialog(context, TimeSlot.zero(timeTable.id!, dayWatch.selectedDay), color: Colors.pink, isfirst: true);
            },
            child: Icon(Icons.add, color: Colors.blueGrey.shade800,),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

class TimeTablePageBody extends StatefulWidget {
  const TimeTablePageBody({
    Key? key,
    required this.w,
    required this.h,
    required this.timeTable,
  }) : super(key: key);

  final double w;
  final double h;
  final TimeTable timeTable;

  @override
  State<TimeTablePageBody> createState() => _TimeTablePageBodyState();
}

class _TimeTablePageBodyState extends State<TimeTablePageBody> {

  late Day_pr dayReader;
  late final AssetImage headerImage;
  late final Timer timer;
  int ticker = 0;


  @override
  void initState() {
    dayReader = context.read<Day_pr>();
    headerImage = const AssetImage('assets/images/blobs_bk2.png');
    timer = Timer.periodic(Durations.d100, (timer) {setState((){ticker++;});});
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
    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);
    final int noOfDays = widget.timeTable.timeSlots[dayWatch.selectedDay].length;

    return Column(

      crossAxisAlignment: CrossAxisAlignment.end,

      children: [

        Container(
              
          width: double.infinity,
          height: widget.h * 0.3,
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
              
          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomRight: Radius.elliptical(widget.w / 3, widget.h / 10),
            ),
            image: DecorationImage(
              image: headerImage,
              fit: BoxFit.cover
            ),
          ),
      
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
              Material(
      
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
                        child: FocusedMenuHolder(
                            
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
                                Utils.showDeleteTableDialog(context, widget.timeTable);
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
                                Utils.showEditDialog(context, TimeSlot.zero(widget.timeTable.id!, dayWatch.selectedDay), color: Colors.pink, isfirst: true);
                              }, 
                              item: focusedMenuItems[6],
                            ),
                          ],
                            
                          child: const Icon(
                            Icons.more_vert, 
                            color: Colors.white, size: 30,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
              Text(
                widget.timeTable.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 0.8
                ),
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
              Column(
                children: days.map((day) => 
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 6, 20),
                    child: DayTile(
                      day: day, width: w * 0.1, 
                      onDayChange: (){
                        dayReader.setDay(days.indexOf(day));
                        ticker = 0;
                      }
                    ),
                  )
                ).toList()
              ),
        
              //Time Slot Tiles for currently selected day.
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const BouncingScrollPhysics(),
                  itemCount: noOfDays + 1,
                  itemBuilder: ((context, index) {

                    bool beginAnimation = ticker > index + 2;

                    return index == noOfDays
                    ? Spaces.vertical60
                    : AnimatedTimeSlotTile(
                      beginAnimation: beginAnimation, 
                      timeSlot: widget.timeTable.timeSlots[dayWatch.selectedDay][index],
                    );
                    // return OpacityContainer(beginAnimate: beginAnimation, color: Colors.purple);
                    }
                  )
                ),
              ),
            ],
          ),
        ),
      ],
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
