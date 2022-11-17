
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Providers.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/TimeTableScreen.dart';

import '../Classes/TimeTable.dart';
import '../Databases/ServicesPref.dart';

class TimeTableTile extends StatelessWidget{
  const TimeTableTile({
    Key? key,
    required this.animate1,
    required this.animate2,
    required this.table,
  }) : super(key: key);

  final bool animate1;
  final bool animate2;
  final TimeTable table;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        _AttributesChip(animate1: animate1, table: table),

        Spaces.vertical20,

        _MainTile(animate2: animate2, table: table),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _MainTile extends StatelessWidget {
  const _MainTile({
    Key? key,
    required this.animate2,
    required this.table,
  }) : super(key: key);

  final bool animate2;
  final TimeTable table;
  
  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    
    return AnimatedOpacity(
      opacity: animate2? 1: 0,
      curve: Curves.decelerate,
      duration: Durations.d600,

      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: colorWatch.shadow,
        elevation: 16,
        borderRadius: BorderRadius.circular(80),

        child: Material(
          type: MaterialType.transparency,

          child: InkWell(
            splashColor: colorWatch.splash,
            highlightColor: colorWatch.splash,
            borderRadius: BorderRadius.circular(20),

            onTap: (){
              Provider.of<Day_pr>(context, listen: false).setDay(DateTime.now().weekday - 1);
              var pageRouteBuilder = PageRouteBuilder(
                  pageBuilder: ((context, animation, secondaryAnimation) => 
                    TimeTableScreen(timeTable: table)
                  ),
                  transitionDuration: Durations.d500,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) => 
                    FadeThroughTransition(
                      animation: animation, 
                      secondaryAnimation: secondaryAnimation,
                      fillColor: colorWatch.background,
                      child: child,
                    ),
                );
              Navigator.of(context).push(  
                pageRouteBuilder
              );
            },
            onLongPress: (){
              Utils.showDeleteTableDialog(context, table);
            },

            child: Ink(
              width: Utils.screenWidthPercentage(context, 0.9),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: Decorations.tableTile(colorWatch.onBackground),
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    table.title,
                    style: TextStyles.h2light(colorWatch.foreground),
                  ),

                  Spaces.vertical20,
            
                  _WorkLoadBars(table: table),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _AttributesChip extends StatelessWidget {
  const _AttributesChip({
    Key? key,
    required this.animate1,
    required this.table,
  }) : super(key: key);

  final bool animate1;
  final TimeTable table;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(

      duration: Durations.d500,
      curve: Curves.easeOutQuint,
      scale: animate1? 1: 0,

      child: PhysicalModel(

        elevation: 12,
        color: Colors.transparent,
        shadowColor: Colors.blueGrey.shade300,
        borderRadius: BorderRadius.circular(80),
    
        child: Container(
          decoration: Decorations.decoratedContainer,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          height: 100,
          child: Row(
            children: [
              
              _RichText(text1: ' Last Modified:', text2: DateFormat('M-d-y').format(DateTime.now()),),
              
              const Spacer(),
              
              _RichText(text1: 'Total Slots:', text2: table.totalSlots.toString())
            ],
          ),
        ),
      ),
    );
  }
}

class _RichText extends StatelessWidget {
  const _RichText({
    Key? key,
    required this.text1,
    required this.text2
  }) : super(key: key);

  final String text1, text2;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$text1\n',
            style: TextStyles.b4(Prefs.isDarkMode? Colors.white: colorWatch.foreground.withOpacity(0.75)),
          ),
          TextSpan(
            text: text2,
            style: TextStyles.bk4(Prefs.isDarkMode? Colors.white.withOpacity(0.8): colorWatch.foreground.withOpacity(0.75)),
          ),
        ]
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _WorkLoadBars extends StatelessWidget{
  const _WorkLoadBars({
    Key? key,
    required this.table,
  }) : super(key: key);

  final TimeTable table;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(7, (index) {

        double maxLoad = table.maxLoad;
        return Padding(
  
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Stack(  
            clipBehavior: Clip.none,
            children: [
  
              Text(
                days[index].substring(0,1),
                style: TextStyles.b2(colorWatch.foreground.withOpacity(0.5))
              ),

              Positioned(
                left: 30, top: 6,
                child: buildWorkLoadBar(table.dayLoad(index), maxLoad, colorWatch.foreground)
              ),
            ],
          ),
        );
      }
    ));
  }

  Widget buildWorkLoadBar(double hours, double maxLoad, Color textcolor) {
    
    return Row(
      children: [
        Container(
          width: 400 * 0.52 * hours / maxLoad + 12,
          height: 12,
          decoration: Decorations.workLoadBar
        ),

        Spaces.horizontal20,

        if(hours > 0)
          Text(
            hours.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: textcolor,
              fontSize: 14,
            ),
          )
      ],
    );
  }
}