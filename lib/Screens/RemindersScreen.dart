
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/Helpers.dart';
import 'package:timetable_app/Widgets/LinearFlowFAB.dart';

import '../Classes/Reminder.dart';
import '../Globals/Providers.dart';
import '../Widgets/EditReminderScreen.dart';
import '../Widgets/ReminderTile.dart';

class RemindersScreen extends StatefulWidget{
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {

  late final Timer timer;
  int ticker = 0;

  @override
  void initState() {
    timer = Timer.periodic(Durations.d100, (timer) =>
      setState(() {
        ticker++;
      })
    );
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

    return SafeArea(

      child: Scaffold(

        backgroundColor: colorWatch.background,

        floatingActionButton: const LinearFlowFAB(),

        body: SingleChildScrollView(

          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const BackgroundText(title: 'Reminders'),

              ReminderHeader(animate: ticker > 2),

              Spaces.vertical60,

              RemindersList(animate: ticker > 5),

              Center(child: _AddButton())
            ],
          ),
        ),
      )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


class RemindersList extends StatelessWidget{

  const RemindersList({
    super.key,
    required this.animate
  });

  final bool animate;

  @override
  Widget build(BuildContext context) {

    final Reminder_pr remWatch = context.watch<Reminder_pr>();

    return AnimatedOpacity(

      duration: Durations.d600,
      opacity: animate? 1: 0,

      child: AnimatedSlide(
    
        duration: Durations.d500,
        curve: Curves.easeOutQuint,
        offset: Offset(animate? 0: 0.3, 0),
    
        child: Column(
    
          children: remWatch.reminders.map((reminder)
            => Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ReminderTile(reminder: reminder),
            )).toList(),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


class _AddButton extends StatelessWidget {
  _AddButton({
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return IconButton(
      onPressed: (){
        Navigator.of(context).push(
          Utils.buildFadeThroughTransition(const EditReminderScreen(), colorWatch.background)
        );
      },
      splashRadius: 48,
      tooltip: 'Add reminder',
      icon: Icon(
        Icons.add, size: 36, color: colorWatch.foreground,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ReminderHeader extends StatelessWidget {
  const ReminderHeader({
    Key? key,
    required this.animate,
  }) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();

    return AnimatedOpacity(

      opacity: animate? 1: 0,
      duration: Durations.d600,

      child: AnimatedSlide(
    
        duration: Durations.d500,
        curve: Curves.easeOutQuint,
        offset: Offset(0, animate? 0: -0.3),
    
        child: PhysicalModel(
      
          color: Colors.transparent,
          shadowColor: colorWatch.shadow_alt,
          elevation: 16,
          borderRadius: BorderRadius.circular(80),
      
          child: Container(
            
            width: double.infinity,
            height: 120,
            alignment: const Alignment(0, -0.3),
            decoration: Decorations.decoratedContainer,
        
            // child: Text(
            //   'Reminders',
            //   style: TextStyles.bk1(),
            // ),
          ),
        ),
      ),
    );
  }
}