
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Miscellaneous/ExtensionMethods.dart';
import 'package:timetable_app/Widgets/Helpers.dart';
import '../Classes/TimeSlot.dart';
import '../Classes/TimeTable.dart';
import '../Globals/Providers.dart';
import '../Globals/enums.dart';
import '../Widgets/LinearFlowFAB.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      
      child: Container(
        
        decoration: Decorations.homeImage,
        
        child: Stack(
          children: [

            Positioned.fill(
              child: BackdropFilter(
                  
                // filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),

                child: Container(

                  decoration: Decorations.homeVignette,
                  width: Utils.screenWidthPercentage(context, 1),
                  height: Utils.screenHeightPercentage(context, 1),
                )
              )
            ),

            const Scaffold(
      
              backgroundColor: Colors.transparent,
            
              body: HomeBody(),
      
              floatingActionButton: LinearFlowFAB(),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {

  bool animate1 = false;
  bool animate2 = false;

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Reminder_pr remWatch = Provider.of<Reminder_pr>(context);
    final Table_pr tableWatch = Provider.of<Table_pr>(context);
    
    final int currentDay = DateTime.now().weekday - 1;

    final TimeTable homeTable = tableWatch.tables[Prefs.homeTable];
    final TimeSlot currentSlot = homeTable.currentSlot(currentDay) ?? TimeSlot.zero(-1,-1).copyWith(title: 'None');
    final TimeSlot nextSlot = homeTable.nextSlot(currentDay) ?? TimeSlot.zero(-1,-1).copyWith(title: 'None');

    return Column(
      
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        if(remWatch.reminders.isNotEmpty)
          Spaces.vertical50,

        if(remWatch.reminders.isNotEmpty)
          AnimatedOpacity(

            opacity: animate1? 1: 0,
            duration: Durations.d600,

            child: AnimatedSlide(
              
              duration: Durations.d500,
              curve: Curves.easeOutQuint,
              offset: Offset(animate1? 0: 0.3, 0),
              
              child: _ReminderTile(),
            ),
          ),

        const Spacer(),
          
        _SlotDetails(
          animate: animate2,
          label: 'current:', 
          value: currentSlot.title,
          timings: currentSlot.title == 'None'?
          '': '${currentSlot.startTime.toString().substring(10,15)} - ${currentSlot.endTime.toString().substring(10,15)}',
        ),

        Spaces.vertical30,
        
        _SlotDetails(
          animate: animate2,
          label: 'upcoming:', 
          value: nextSlot.title,
          timings: nextSlot.title == 'None'?
          '': '${nextSlot.startTime.toString().substring(10,15)} - ${nextSlot.endTime.toString().substring(10,15)}',
        ),

        const Spacer()
      ],
    );
  }
  
  Future<void> startAnimation() async {
    await Future.delayed(Durations.d400);
    setState(() {
      animate1 = true;
    });

    await Future.delayed(Durations.d200);
    setState(() {
      animate2 = true;
    });
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Reminder_pr remWatch = context.watch<Reminder_pr>();

    return Container(
            
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
            
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white12,
      ),
            
      child: Column(
        children: [
          Text(
            remWatch.reminders.first.dateTime.isSameDayAs(DateTime.now())
            ? 'Today'
            : DateFormat('EEE - MMM d, y').format(remWatch.reminders.first.dateTime),
            style: TextStyles.bk4(Colors.blueGrey.shade200),
          ),
            
          Spaces.vertical10,
            
          Text(
            remWatch.reminders.first.title,
            style: TextStyles.h1light(Colors.blueGrey.shade300)
          ),
            
          Spaces.vertical20,
            
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              DateFormat('K : mm a').format(remWatch.reminders.first.dateTime),
              style: TextStyle(
                color: Colors.blueGrey.shade200,
                fontFamily: 'Ultra'
              )
            ),
          )
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _SlotDetails extends StatelessWidget {
  const _SlotDetails({
    Key? key,
    required this.animate,
    required this.label,
    required this.value,
    required this.timings
  }) : super(key: key);

  final bool animate;
  final String label, value, timings;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return AnimatedOpacity(

      duration: Durations.d600,
      opacity: animate? 1: 0,

      child: AnimatedSlide(
    
        duration: Durations.d500,
        curve: Curves.easeOutQuint,
        offset: Offset(0, animate? 0: 0.2),
    
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
      
              TextSpan(
                text: '$label\n\n',
                style: TextStyles.h0(24, color: const Color.fromARGB(200, 239, 250, 255)),
              ),
              TextSpan(
                text: '$value\n',
                style: TextStyles.h1light(const Color.fromARGB(255, 239, 250, 255)),
              ),
              TextSpan(
                text: timings,
                style: TextStyles.h4(const Color.fromARGB(200, 239, 250, 255))
              )
            ]
          ),
        ),
      ),
    );
  }
}