
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
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

    final double h = Utils.screenHeightPercentage(context, 1);
    final w = Utils.screenWidthPercentage(context, 1);

    return SafeArea(

      child: Scaffold(
        
        backgroundColor: Colors.grey.shade200,
    
        body: Stack(
          children: [
            
            RemindersListView(
              animate: ticker > 6,
            ),
            
            ReminderHeader(
              animate1: ticker > 1,
              animate2: ticker > 6,
            ),
          ],
        ),
    
        floatingActionButton: const LinearFlowFAB(),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class RemindersListView extends StatelessWidget {
  const RemindersListView({
    Key? key,
    required this.animate
  }) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {

    final Reminder_pr remWatch = context.watch<Reminder_pr>();

    final double h = Utils.screenHeightPercentage(context, 1);

    final _createEditReminderScreen = PageRouteBuilder(
      pageBuilder: ((context, animation, secondaryAnimation) => 
        EditReminderScreen(reminder: Reminder.zero, isFirst: true,)
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

    return AnimatedOpacity(
      duration: Durations.d300,
      opacity: animate? 1: 0,
      child: AnimatedPadding(
        duration: Durations.d200,
        padding: EdgeInsets.only(
          left: animate? 20: 0,
          right: animate? 20: 40,
        ),
        child: ListView.builder(  
          itemCount: remWatch.reminders.length + 2,
          itemBuilder: ((context, index) =>
          index == 0
          ? Spaces.vertical(h * 0.24)
          : index == remWatch.reminders.length + 1
          ? Padding(
            padding: EdgeInsets.only(bottom: h * 0.04),
            child: Material(
              type: MaterialType.transparency,
              child: IconButton(
                onPressed: (){
                  Navigator.of(context).push(_createEditReminderScreen);
                },
                splashRadius: 48,
                splashColor: Colors.black26,
                highlightColor: Colors.black26,
                icon: const Icon(
                  Icons.add, size: 36, color: Color.fromRGBO(55, 71, 79, 1),
                ),
              ),
            ),
          )
          : Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: ReminderTile(reminder: remWatch.reminders[index - 1]),
          )     
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ReminderHeader extends StatelessWidget {
  const ReminderHeader({
    Key? key,
    required this.animate1,
    required this.animate2
  }) : super(key: key);

  final bool animate1;
  final bool animate2;

  @override
  Widget build(BuildContext context) {

    final double h = Utils.screenHeightPercentage(context, 1);
    final double w = Utils.screenWidthPercentage(context, 1);

    return AnimatedContainer(
      
      duration: Durations.d500,
      curve: Curves.easeInOutQuint,
      height: animate1
      ? h * 0.146 : 0,
      alignment: const Alignment(0,-0.2),
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(horizontal: animate1 ? 0: w),
      decoration: Decorations.reminderHeader(w),
      
      child: AnimatedOpacity(
        duration: Durations.d200,
        opacity: animate2
        ? 1 : 0,
        
        child: Stack(

          clipBehavior: Clip.none,
          children: [
      
            Positioned(
              top: -30,
              right: -80,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationZ(5.7),
                child: const Icon(Icons.notifications_active, size: 80, color: Color.fromRGBO(214, 214, 214, 0.4)))
            ),
      
            const Positioned(
              top: -30,
              left: -78,
              child: Icon(
                Icons.timelapse_rounded, 
                size: 120,
                color: Color.fromRGBO(214, 214, 214, 0.4)
              ),
            ),
      
            RichText(
              text: TextSpan(
                children: appBarHeader('R', 'eminders')
              )
            )
          ],
        ),
      )
    );
  }
}