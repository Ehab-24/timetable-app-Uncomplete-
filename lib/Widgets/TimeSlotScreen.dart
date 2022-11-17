
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/TimeSlot.dart';
import 'package:timetable_app/Databases/LocalDatabase.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Widgets/Helpers.dart';

import '../Databases/ServicesPref.dart';
import '../Globals/Providers.dart';
import '../Globals/Reals.dart';
import '../Globals/Utils.dart';
import '../Miscellaneous/ExtensionMethods.dart';



// late TimeSlot newSlot;
// int selectedDay = DateTime.now().weekday - 1;

class TimeSlotScreen extends StatefulWidget {
  const TimeSlotScreen({
    Key? key,
    required this.isfirst,
    required this.timeSlot,
    required this.color,
  }) : super(key: key);

  final TimeSlot timeSlot;
  final bool isfirst;
  final Color color;

  @override
  State<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends State<TimeSlotScreen> {

  late final NewSlot_pr slotReader;

  @override
  void initState() {
    slotReader = context.read<NewSlot_pr>();
    slotReader.timeSlot = widget.timeSlot.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final NewSlot_pr slotWatch = context.watch<NewSlot_pr>();

    return GestureDetector(

      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },

      child: Scaffold(
    
        backgroundColor: colorWatch.background,
    
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 20, 30),
          child: AnimatedDualFAB(
            onSave: _onSave,
            scaleSomparator: slotWatch.timeSlot.isSameAs(widget.timeSlot),
          ),
        ),
    
        body: SingleChildScrollView(
    
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
    
          child: Form(
            key: Utils.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const _TimePickers(),
          
                Spaces.vertical40,
          
                const _WeekDayChips(),
    
                Spaces.vertical20,
          
                BackgroundTextMini(title: 'Title', color: Prefs.isDarkMode? Colors.white54: Colors.black26,),
          
                Stack(
                  children: [
                    PhysicalModel(
                      color: Colors.transparent,
                      shadowColor: colorWatch.shadow,
                      elevation: 16,
                      borderRadius: BorderRadius.circular(80),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 104,
                      ),
                    ),
                    TextFieldBold(
                      maxLength: 8,
                      initialValue: slotWatch.timeSlot.title,
                      onChanged: (title) => slotReader.setTitle(title),
                      validator: ((title){
                        if(title == null || title == ''){
                          return 'Title must not be empty';
                        }
                        return null;
                      })
                    ),
                  ],
                ),
                
                Spaces.vertical40,
    
                BackgroundTextMini(title: 'Subtitle', color: Prefs.isDarkMode? Colors.white54: Colors.black26,),
          
                TextFieldBold(
                  initialValue: slotWatch.timeSlot.subtitle, 
                  onChanged: (subtitle) => slotReader.setSubtitle(subtitle),
                ),
    
                Spaces.vertical80
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {

    final NewSlot_pr slotReader = context.read<NewSlot_pr>();

    bool isvalid = Utils.formKey.currentState!.validate();
    if(isvalid){
      try{
        Table_pr tableReader = Provider.of<Table_pr>(context, listen: false);
      
        slotReader.timeSlot.parentId = tableReader.tables[currentTableIndex].id!;

        Utils.formKey.currentState!.save();
        slotReader.timeSlot.validate();
        tableReader.validate(slotReader.timeSlot);

        if(widget.isfirst){
          TimeSlot newSlot = await LocalDatabase.instance.addSlot(slotReader.timeSlot);
          tableReader.addSlot(newSlot);
        }
        else{
          await LocalDatabase.instance.updateSlot(slotReader.timeSlot);
          tableReader.updateSlot(slotReader.timeSlot, widget.timeSlot.day); 
          tableReader.reformList(slotReader.timeSlot, widget.timeSlot.day);
        }
   
        //Sort the TimeTable
        tableReader.sort(slotReader.timeSlot.day, slotReader.timeSlot.parentId);

        if(!mounted){
          return;
        }

        Navigator.of(context).pop();
      }
      catch (e){
        Utils.showErrorDialog(context, e.toString());
      }
    }
  }
}

class _WeekDayChips extends StatefulWidget {
  const _WeekDayChips({
    Key? key,
  }) : super(key: key);

  @override
  State<_WeekDayChips> createState() => _WeekDayChipsState();
}

class _WeekDayChipsState extends State<_WeekDayChips> {

  late final NewSlot_pr slotReader;

  @override
  void initState() {
    slotReader = context.read<NewSlot_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final w = Utils.screenWidthPercentage(context, 1);

    return SizedBox(
      height: w * 0.42,
      width: w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: w * 0.05,
            child: Icon(Icons.brightness_low_outlined, size: 200, color: colorWatch.foreground.withOpacity(0.1),)
          ),
          ...weekDayChips(w)
        ]
      ),
    );
  }

  List<Widget> weekDayChips(double w){
    List<Widget> chips = [];
    for(int i = 0; i < days.length; i++) {
      chips.add(weekDayChip(i, w));
    }
    return chips;
  }

  Widget weekDayChip(int index, double w) {

    final Color_pr colorWatch = context.watch<Color_pr>();
    final NewSlot_pr slotWatch = context.watch<NewSlot_pr>();

    bool isSelected = slotWatch.timeSlot.day == index;
    double _left = index > 3? (index - 4) * w * 0.22 + w * 0.1 :index * w * 0.22;
    double _top = index > 3? w * 0.2: 0;

    return AnimatedPositioned(
      
      duration: Durations.d600,
      curve: Curves.easeOutQuint,
          
      left: _left,
      top: isSelected? _top - 12: _top,
      child: GestureDetector(
        onTap: (){
          slotReader.setDay(index);
        },
        child: Container(
                      
          width: w * 0.1425,
          height: w * 0.1425,
          alignment: Alignment.center,
          margin: EdgeInsets.all(w * 0.0375),
          
          decoration: Decorations.dayChip(isSelected),
          
          child: Text(
            days[index].substring(0,3),
            style: TextStyles.b4(colorWatch.onBackground,)
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _TimePickers extends StatefulWidget {
  const _TimePickers({
    Key? key,
  }) : super(key: key);

  @override
  State<_TimePickers> createState() => _TimePickersState();
}

class _TimePickersState extends State<_TimePickers> {

  late final NewSlot_pr slotReader;

  @override
  void initState() {
    slotReader = context.read<NewSlot_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final NewSlot_pr slotWatch = context.watch<NewSlot_pr>();

    final width = Utils.screenWidthPercentage(context, 0.43);
    final height = Utils.screenHeightPercentage(context, 0.2);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      
        Column(
          children: [
            Text(
              slotWatch.timeSlot.startTime.hour12Format(),
              style: TextStyles.bk4(Prefs.isDarkMode? Colors.white60: Colors.black38),
            ),
            Spaces.vertical10,
            LargeButton(
              height: height, 
              width: width, 
              label: 'Start Time', 
              icon: Icons.access_time,
              onTap: _onTapStartTime
            ),
          ],
        ),
        Column(
          children: [
            LargeButton(
              height: height, 
              width: width, 
              label: 'End Time', 
              icon: Icons.access_time,
              onTap: _onTapEndTime
            ),
            Spaces.vertical10,
            Text(
              slotWatch.timeSlot.endTime.hour12Format(),
              style: TextStyles.bk4(Prefs.isDarkMode? Colors.white60: Colors.black38),
            ),
          ],
        ),
      ],
    );
  }

  void _onTapStartTime () async {
    FocusManager.instance.primaryFocus!.unfocus();
    slotReader.setStartTime(
      await showTimePicker(
        context: context,
        helpText: 'Starting Time',
        cancelText: 'Cancel',
        confirmText: 'Ok',
        initialEntryMode: TimePickerEntryMode.dialOnly,
        initialTime: slotReader.timeSlot.startTime,
      ) ?? slotReader.timeSlot.startTime
    );
  }
  void _onTapEndTime () async {
    FocusManager.instance.primaryFocus!.unfocus();
    slotReader.setEndTime(
      await showTimePicker(
        context: context,
        helpText: 'Ending Time',
        cancelText: 'Cancel',
        confirmText: 'Ok',
        initialEntryMode: TimePickerEntryMode.dialOnly,
        initialTime: slotReader.timeSlot.endTime,
      ) ?? slotReader.timeSlot.endTime
    );
    print(slotReader.timeSlot.endTime.period.toString(),);
  }
}