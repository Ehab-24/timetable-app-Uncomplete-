
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Reals.dart';

import '../Globals/Providers.dart';
import '../Globals/enums.dart';

class DayTile extends StatefulWidget{
  const DayTile({
    Key? key,
    required this.day,
    required this.width,
    required this.onDayChange,
  }) : super(key: key);

  final String day;
  final double width;
  final Function() onDayChange;

  @override
  State<DayTile> createState() => _DayTileState();
}

class _DayTileState extends State<DayTile> {

  late Day_pr dayReader;

  @override
  void initState() {
    dayReader = context.read<Day_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Day_pr dayWatch = context.watch<Day_pr>();

    final int dayIndex = days.indexOf(widget.day);
    final bool isSelected = dayIndex == dayWatch.selectedDay;
    
    return InkWell(

      onTap: widget.onDayChange,

      child: AnimatedContainer(
    
        duration: Durations.d300,
        curve: Curves.decelerate,

        width: widget.width,
        height: isSelected
        ? 50
        : 35,
        alignment: Alignment.center,
    
        decoration: BoxDecoration(
          
          color: isSelected
          ? Colors.pink  //TODO: Parent table should provide this color
          : Colors.white.withOpacity(0.8),

          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isSelected
              ? Colors.black54
              : Colors.black12,
              offset: const Offset(3,3),
              blurRadius: 3
            )
          ],
        ),
    
        child: Text(
          widget.day.substring(0, 3),
          style: TextStyle(
            fontSize: isSelected
            ? 16
            : 14,
            color: isSelected
            ? Colors.white
            :Colors.black,
          ),
        ),
      ),
    );
  }
}