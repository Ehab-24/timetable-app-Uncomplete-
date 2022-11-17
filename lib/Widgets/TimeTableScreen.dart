// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/Helpers.dart';
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
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWatch.background,
        body: TimeTablePageBody(
          timeTable: timeTable,
        ),
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
        onPressed: () {
          Navigator.of(context).pop();
        },
        heroTag: 'main-btn',
        splashColor: colorWatch.splash,
        backgroundColor: colorWatch.onBackground,
        foregroundColor: colorWatch.foreground,
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class TimeTablePageBody extends StatefulWidget {
  const TimeTablePageBody(
      {Key? key, required this.timeTable})
      : super(key: key);

  final TimeTable timeTable;

  @override
  State<TimeTablePageBody> createState() => _TimeTablePageBodyState();
}

class _TimeTablePageBodyState extends State<TimeTablePageBody> {
  late Day_pr dayReader;
  late final Timer timer;
  int ticker = 0;
  bool animate1 = false, animate2 = false;

  @override
  void initState() {
    startAnimation();

    timer = Timer.periodic(Durations.d100, (timer) {
      setState(() {
        ticker++;
      });
    });
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

    final w = Utils.screenWidthPercentage(context, 1);
    final h = Utils.screenHeightPercentage(context, 1);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          _TopContainer(animate: animate1, timeTable: widget.timeTable,),

          SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 60, top: 60),
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Spaces.horizontal20,
                ...List<Widget>.generate(
                  7,
                  (index) => AnimatedScale(
                      scale: animate2 ? 1 : 0,
                      duration: Durations.d500,
                      curve: Curves.easeOutQuint,
                      child: dayChip(index, w)),
                ),
                Spaces.horizontal20,
              ])),

          _SlotsList(
              animate: ticker > 4,
              slots: widget.timeTable.timeSlots[dayWatch.selectedDay]),

          IconButton(
            onPressed: () {
              Navigator.of(context).push(Utils.buildFadeThroughTransition(
                  TimeSlotScreen(
                    timeSlot: TimeSlot.zero(
                        widget.timeTable.id!, dayWatch.selectedDay),
                    isfirst: true,
                    color: Colors.pink,
                  ),
                  colorWatch.background));
            },
            splashRadius: 48,
            icon: Icon(
              Icons.add,
              size: 36,
              color: colorWatch.foreground,
            ),
          )
        ],
      ),
    );
  }

  Future<void> startAnimation() async {
    Future.delayed(Durations.d200, () {
      setState(() {
        animate1 = true;
      });
    });
    Future.delayed(Durations.d600, () {
      setState(() {
        animate2 = true;
      });
    });
  }

  Widget dayChip(int index, double w) {
    final Day_pr dayWatch = context.watch<Day_pr>();

    final _maxRadius = w * 0.15;
    bool _isSelected = index == dayWatch.selectedDay;

    return GestureDetector(
      onTap: () {
        if (index == dayReader.selectedDay) {
          return;
        }
        dayReader.setDay(index);
        setState(() {
          ticker = 2;
        });
      },
      child: AnimatedSlide(
        offset: Offset(0, _isSelected ? -0.3 : 0),
        duration: Durations.d600,
        curve: Curves.easeOutQuint,
        child: Container(
          width: _maxRadius,
          height: _maxRadius,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: w * 0.026),
          decoration: Decorations.dayChip_alt(index == dayWatch.selectedDay),
          child: Text(
            days[index].substring(0, 3),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _TopContainer extends StatelessWidget {
  const _TopContainer({
    Key? key,
    required this.animate,
    required this.timeTable
  }) : super(key: key);

  final bool animate;
  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {
    
    final Color_pr colorWatch = context.watch<Color_pr>();

    return AnimatedOpacity(
      opacity: animate ? 1 : 0,
      duration: Durations.d600,
      child: AnimatedScale(
        duration: Durations.d500,
        curve: Curves.easeOutQuint,
        scale: animate ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PhysicalModel(
            color: Colors.transparent,
            shadowColor: colorWatch.shadow_alt,
            elevation: ELEVATION,
            borderRadius: BORDER_RADIUS,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
              decoration: Decorations.decoratedContainer,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TableInfo(
                    timeTable: timeTable,
                  ),
                  const Spacer(),
                  _ActionButtons(
                    timeTable: timeTable,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return Row(
      children: [
        Column(
          children: [
            SmallButton(
              onTap: () {
                Utils.showEditTableDialog(context);
              },
              footer: 'Edit',
              icon: Icon(Icons.edit, color: colorWatch.background),
              width: 50,
              height: 50,
            ),
            Spaces.vertical20,
            SmallButton(
              onTap: () {
                Utils.showDeleteTableDialog(context, timeTable);
              },
              footer: 'Delete',
              icon: Icon(Icons.delete_forever, color: colorWatch.background),
              width: 50,
              height: 50,
            ),
          ],
        ),
        Spaces.horizontal20,
        Column(
          children: [
            SmallButton(
              onTap: () {
                Utils.showClearTableDialog(context, timeTable);
              },
              footer: 'Clear',
              icon: Icon(Icons.delete, color: colorWatch.background),
              width: 50,
              height: 50,
            ),
            Spaces.vertical20,
            SmallButton(
              onTap: () {
                Prefs.setHomeTable(currentTableIndex);
                Utils.showSnackBar(
                    context, '"${timeTable.title}" marked as home table.',
                    backgroundColor: Colors.lightBlueAccent);
              },
              footer: 'Home',
              icon: Icon(
                Icons.home_work, 
                color: Prefs.homeTable == currentTableIndex
                  ? Colors.red.shade200
                  : colorWatch.background,
              ),
              width: 50,
              height: 50,
            ),
          ],
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _TableInfo extends StatelessWidget {
  const _TableInfo({
    Key? key,
    required this.timeTable,
  }) : super(key: key);

  final TimeTable timeTable;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();
    final Table_pr tableWatch = context.watch<Table_pr>();

    final int currentDay = DateTime.now().weekday - 1;

    final TimeSlot currentSlot = timeTable.currentSlot(currentDay) ??
        TimeSlot.zero(-1, -1).copyWith(title: 'None');
    final TimeSlot nextSlot = timeTable.nextSlot(currentDay) ??
        TimeSlot.zero(-1, -1).copyWith(title: 'None');

    return SizedBox(
      width: 200,
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
          text: timeTable.title,
          style: TextStyles.h1light(colorWatch.background),
        ),
        TextSpan(
            text: '\n\n\nmodified: ',
            style: TextStyles.h0(18, color: colorWatch.background)),
        TextSpan(
            text: DateFormat('MM-d-y').format(timeTable.lastModified),
            style: TextStyles.b4(colorWatch.background)),
        Prefs.homeTable == currentTableIndex
            ? TextSpan(children: [
                TextSpan(
                    text: '\ncurrent: ',
                    style: TextStyles.h0(18, color: colorWatch.background)),
                TextSpan(
                    text: currentSlot.title,
                    style: TextStyles.b2(colorWatch.background)),
                TextSpan(
                    text: '\nupcoming: ',
                    style: TextStyles.h0(18, color: colorWatch.background)),
                TextSpan(
                    text: nextSlot.title,
                    style: TextStyles.b2(colorWatch.background)),
              ])
            : TextSpan(
                text: '\n\nTable not set as home.',
                style: TextStyles.b5(colorWatch.background))
      ])),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _SlotsList extends StatelessWidget {
  const _SlotsList({Key? key, required this.animate, required this.slots})
      : super(key: key);

  final bool animate;
  final List<TimeSlot> slots;

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: animate ? 1 : 0,
        curve: Curves.easeOut,
        duration: animate ? Durations.d600 : Durations.zero,
        child: AnimatedSlide(
          offset: Offset(animate ? 0 : 0.3, 0),
          duration: animate ? Durations.d500 : Durations.zero,
          curve: Curves.easeOutQuint,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                children: slots
                    .map((slot) => Padding(
                          padding: const EdgeInsets.only(bottom: 60),
                          child: TimeSlotTile(
                            timeSlot: slot,
                            color: Colors.pink,
                          ),
                        ))
                    .toList()),
          ),
        ),
      );
}
