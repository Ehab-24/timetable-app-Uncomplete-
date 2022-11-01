
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/FocusedMenuItem.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/TimeSlotScreen.dart';

import '../Classes/TimeSlot.dart';
import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/Reals.dart';
import 'TimeSlotTile.dart';


const int initialDelay = 3;
const Color color = Colors.pink;

class TimeTableScreen extends StatelessWidget {
  const TimeTableScreen({
    Key? key,
    required this.timeTable,
    required this.headerImage,
  }) : super(key: key);

  final TimeTable timeTable;
  final AssetImage headerImage;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return SafeArea(
      child: Scaffold(
    
        backgroundColor: colorWatch.background,
    
        body: TimeTablePageBody(timeTable: timeTable, headerImage: headerImage,),

        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

        floatingActionButton: const _FAB(),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _FAB extends StatelessWidget {
  const _FAB({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: Decorations.FAB(colorWatch.foreground.withOpacity(0.5)),

      child: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
        splashColor: colorWatch.splash,
        backgroundColor: colorWatch.onBackground,
        foregroundColor: colorWatch.foreground,
        tooltip: 'back',
        heroTag: 'back-btn',
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class TimeTablePageBody extends StatefulWidget {
  const TimeTablePageBody({
    Key? key,
    required this.timeTable,
    required this.headerImage
  }) : super(key: key);

  final TimeTable timeTable;
  final AssetImage headerImage;

  @override
  State<TimeTablePageBody> createState() => _TimeTablePageBodyState();
}

class _TimeTablePageBodyState extends State<TimeTablePageBody> {

  late Day_pr dayReader;
  late final Timer timer;

  int ticker = 0;

  @override
  void initState() {
    timer = Timer.periodic(Durations.d100, (timer) =>
      setState(() =>
        ticker++ 
      )
    );
    dayReader = context.read<Day_pr>();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final Day_pr dayWatch = context.watch<Day_pr>();

    final int noOfSlots = widget.timeTable.timeSlots[dayWatch.selectedDay].length;
    
    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      physics: const BouncingScrollPhysics(),

      child: Column(
        children: [

          PhysicalModel(
            color: Colors.transparent,
            shadowColor: colorWatch.shadow_alt,
            elevation: ELEVATION,
            borderRadius: BORDER_RADIUS,

            child: Container(
              height: 200,
              width: double.infinity,
              decoration: Decorations.decoratedContainer,

              // child: ,
            ),
          ),

          Spaces.vertical60,

          _SlotsList(animate: ticker > 5, slots: widget.timeTable.timeSlots[dayWatch.selectedDay]),

          Spaces.vertical60,

          IconButton(
            onPressed: (){
              final _timeSlotScreen = PageRouteBuilder(
                pageBuilder: ((context, animation, secondaryAnimation) => 
                  TimeSlotScreen(isfirst: true, timeSlot: TimeSlot.zero(widget.timeTable.id!, dayWatch.selectedDay), color: Colors.pink,)
                ),
                transitionDuration: Durations.d400,
                transitionsBuilder: ((context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOutQuint;

                  final tween = Tween(begin: begin, end: end);
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  );

                  return SlideTransition(
                    position: tween.animate(curvedAnimation),
                    child: child,
                  );
                })
              );
              Navigator.of(context).push(_timeSlotScreen);
            },
            splashRadius: 48,
            tooltip: 'Add reminder',
            icon: Icon(
              Icons.add, size: 36, color: colorWatch.foreground,
            ),
          )
        ],
      ),
    );
  }
}


class _SlotsList extends StatelessWidget{
  _SlotsList({
    Key? key,
    required this.animate,
    required this.slots
  }) : super(key: key);

  final bool animate;
  final List<TimeSlot> slots;

  @override
  Widget build(BuildContext context) {

    return Column(
    
      children: slots.map((slot)
        => Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: TimeSlotTile(timeSlot: slot, color: Colors.pink,),
        )).toList(),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _TimeTableHeader extends StatelessWidget {
  const _TimeTableHeader({
    Key? key,
    required this.title
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {

    final double w = Utils.screenWidthPercentage(context, 1);

    return SizedBox(
      width: w * 0.75,
      height: 60,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: TextStyles.h2light(Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
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
      child: Row(
      
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      
          IconButton(
            splashRadius: 24,
            onPressed: _onPop, 
            icon: const Icon(Icons.arrow_back, color: Colors.white,)
          ),
      
          _FocusedMenuHolder(timeTable: widget.timeTable,),
        ],
      ),
    );
  }

  void _onPop(){
    dayReader.setDay(DateTime.now().weekday - 1);
    Navigator.of(context).pop();
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

    return FocusedMenuHolder(
        
      menuWidth: 170,
      menuOffset: 12,
      onPressed: (){},
      openWithTap: true,
      blurSize: 0,
      animateMenuItems: false,
        
      menuItems: [

        focusedMenuItem(
          onPressed: (){
            Prefs.setHomeTable(currentTableIndex);
          }, 
          item: focusedMenuItems[0],
        ),
        focusedMenuItem(
          onPressed: (){}, 
          item: focusedMenuItems[1],
        ),
        focusedMenuItem(
          onPressed: (){
            Utils.showEditTableDialog(context);
          }, 
          item: focusedMenuItems[2],
        ),
        focusedMenuItem(
          onPressed: (){
            Utils.showClearTableDialog(context, timeTable);
          },
          item: focusedMenuItems[3],
        ),
        focusedMenuItem(
          onPressed: (){
            Utils.showDeleteTableDialog(context, timeTable);
          },  
          item: focusedMenuItems[4],
        ),
        focusedMenuItem(
          onPressed: (){
            final _timeSlotScreen = PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) => 
                TimeSlotScreen(timeSlot: TimeSlot.zero(timeTable.id!, DateTime.now().weekday - 1), isfirst: true, color: Colors.pink)
              ),
              transitionDuration: Durations.d500,
              transitionsBuilder: ((context, animation, secondaryAnimation, child) { 

                return FadeScaleTransition(
                  animation: animation,
                  child: child,
                );
              })
            );
            Navigator.of(context).push(_timeSlotScreen);
          }, 
          item: focusedMenuItems[5],
        ),
      ],
        
      child: const Icon(Icons.more_vert,color: Colors.white, size: 30,),
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