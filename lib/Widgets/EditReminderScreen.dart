
// ignore_for_file: camel_case_types

import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Widgets/Helpers.dart';

import '../Classes/Reminder.dart';
import '../Databases/LocalDatabase.dart';
import '../Databases/ServicesPref.dart';
import '../Globals/Decorations.dart';
import '../Globals/Providers.dart';
import '../Globals/enums.dart';



class EditReminderScreen extends StatefulWidget{
  const EditReminderScreen({
    super.key,
    this.reminder,
  });

  final Reminder? reminder;

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {

  late final NewReminder_pr newremReader;
  late final Reminder_pr remReader;

  @override
  void initState() {
    remReader = context.read<Reminder_pr>();
    newremReader = context.read<NewReminder_pr>();
    newremReader.reminder = widget.reminder?.copyWith() ?? Reminder.zero;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final NewReminder_pr newremWatch = context.watch<NewReminder_pr>();

    return GestureDetector(

      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },

      child: Scaffold(
    
        backgroundColor: colorWatch.background,
      
        body: SingleChildScrollView(
    
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),      
          physics: const BouncingScrollPhysics(),
    
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
    
              const _DateAndTimeActions(),

              Spaces.vertical60,

              const _UpdatedReminderTile(),

              Spaces.vertical60,

              BackgroundTextMini(title: 'Title', color: Prefs.isDarkMode? Colors.white54: Colors.black,),

              TextFieldBold(
                initialValue: newremWatch.reminder.title,
                onChanged: (title) => newremReader.setTitle(title),
              ),
              
              Spaces.vertical40,

              BackgroundTextMini(title: 'Description', color: Prefs.isDarkMode? Colors.white54: Colors.black,),

              TextFieldBold(
                initialValue: newremWatch.reminder.description,
                onChanged: (desc) => newremReader.setDesc(desc),
              ),

              Spaces.vertical80
            ],
          )
        ),
        
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 20, 20),
          child: AnimatedDualFAB(
            scaleSomparator: newremWatch.reminder.isSameAs(widget.reminder ?? Reminder.zero),
            onSave: (() => _onSave(newremWatch.reminder))
          ),
        ),
      ),
    );
  }

  void _onSave(Reminder reminder) async {
    if(widget.reminder == null){
      Reminder newRem = await LocalDatabase.instance.addReminder(reminder);
      //Add the new Reminder (with id) to provider.
      remReader.add(newRem);
    }
    else{
      //Update in database and provider.
      reminder.id = widget.reminder!.id;
      await LocalDatabase.instance.updateReminder(reminder);
      remReader.update(reminder);
    }
    if(mounted) {
      Navigator.of(context).pop();
    }
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


class _UpdatedReminderTile extends StatelessWidget {
  const _UpdatedReminderTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final NewReminder_pr remWatch = context.watch<NewReminder_pr>();

    return PhysicalModel(

      color: Colors.transparent,
      shadowColor: colorWatch.shadow,
      elevation: ELEVATION,
      borderRadius: BORDER_RADIUS,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: Decorations.decoratedContainer_alt(colorWatch.onBackground),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  remWatch.reminder.title,
                  style: TextStyles.h1(colorWatch.foreground.withOpacity(0.75)),
                ),
                const Spacer(),
                Text(
                  DateFormat('EEE, d, y').format(remWatch.reminder.dateTime),
                  style: TextStyles.b3(colorWatch.foreground),
                ),
              ],
            ),
            Spaces.vertical20,
            Text(
              remWatch.reminder.description,
              style: TextStyles.b4(colorWatch.foreground),
              textAlign: TextAlign.center
            ),

            Spaces.vertical10,
            
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                DateFormat('K : mm a').format(remWatch.reminder.dateTime),
                style: TextStyles.toast(colorWatch.foreground, background: colorWatch.onBackground),
              ),
            )
          ],
        )
      ),
    );
  }
}

class _DateAndTimeActions extends StatefulWidget {

  const _DateAndTimeActions({
    Key? key,
  }) : super(key: key);

  @override
  State<_DateAndTimeActions> createState() => _DateAndTimeActionsState();
}

class _DateAndTimeActionsState extends State<_DateAndTimeActions> {

  late final NewReminder_pr remReader;

  @override
  void initState() {
    remReader = context.read<NewReminder_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final width = Utils.screenWidthPercentage(context, 0.43);
    final height = Utils.screenHeightPercentage(context, 0.2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      
        LargeButton(
          width: width,
          height: height,
          label: 'Time', 
          icon: Icons.timeline_rounded,
          onTap: _onTapTimePicker,
        ),
        LargeButton(
          width: width,
          height: height,
          label: 'Date', 
          icon: Icons.date_range_outlined,
          onTap: _onTapDatePicker,
        )
      ],
    );
  }
//
  void _onTapDatePicker() async {        
    DateTime? dt = await showDatePicker(
      context: context, 
      initialDate: remReader.reminder.dateTime, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (dt == null){
      return;
    }
    remReader.setDateTime(
      DateTime(
        dt.year, dt.month, dt.day, remReader.reminder.dateTime.hour, remReader.reminder.dateTime.minute
    ));
  }
//
  void _onTapTimePicker(){
    DateTime dt = remReader.reminder.dateTime;
      
      Navigator.of(context).push(
        showPicker(
          hourLabel: '',
          minuteLabel: '',
          accentColor: Colors.pink,
          value: TimeOfDay(hour: dt.hour, minute: dt.minute),
          displayHeader: false,
          onChange: ((td) {
            remReader.setDateTime(
              DateTime(
                dt.year, dt.month, dt.day, td.hour, td.minute
              ));
          }),
          buttonsSpacing: 8,
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
          ),
          cancelButtonStyle: ElevatedButton.styleFrom()
        )
      );
  }
}