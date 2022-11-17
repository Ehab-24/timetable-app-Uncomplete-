// ignore_for_file: prefer_final_fields, constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timetable_app/Classes/NotificationApi.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Decorations.dart';
import 'package:timetable_app/Globals/Providers.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/Styles.dart';
import 'package:timetable_app/Globals/Utils.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Miscellaneous/ExtensionMethods.dart';
import 'package:timetable_app/Widgets/LinearFlowFAB.dart';
import 'package:timetable_app/Widgets/Helpers.dart';

import '../Classes/TimeSlot.dart';

const _innerPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 30);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return SafeArea(
      child: AnimatedContainer(
        duration: Durations.d500,
        curve: Curves.easeOut,
        color: colorWatch.background,
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _AllItems(),
          ),
          floatingActionButton: LinearFlowFAB(),
        ),
      ),
    );
  }
}

bool allowNotifications = true;
bool isDarkMode = false;
bool applyHomeScreenImage = true;
bool autoDisposeReminders = true;
bool blurHomeScreenImage = true;
bool gradientHomeScreenImage = true;

class _AllItems extends StatefulWidget {
  const _AllItems({
    Key? key,
  }) : super(key: key);

  @override
  State<_AllItems> createState() => _AllItemsState();
}

class _AllItemsState extends State<_AllItems> {
  late final Timer timer;
  int ticker = 0;

  @override
  void initState() {
    timer = Timer.periodic(Durations.d100, (timer) {
      setState(() {
        ticker++;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () {
              NotificationApi.showScheduledNotification(
                  scheduleTime: DateTime(DateTime.now().year,  DateTime.now().month, DateTime.now().day, DateTime.now().hour,
                    DateTime.now().minute + 2));
            },
            child: const Text('push notification', textAlign: TextAlign.center,)),
        Spaces.vertical50,
        BackgroundText(
            title: 'Profile',
            color: Prefs.isDarkMode ? Colors.white30 : Colors.black12),
        _UserInfo(animate: ticker > 1),
        AnimatedScale(
            duration: Durations.d500,
            curve: Curves.easeOutQuint,
            scale: ticker > 6 ? 1 : 0,
            child: const HorzDivider()),
        BackgroundText(
            title: 'Today',
            color: Prefs.isDarkMode ? Colors.white30 : Colors.black12),
        BackgroundTextMini(
          title: DateFormat.MMMd().format(DateTime.now()),
          color: Prefs.isDarkMode ? Colors.white54 : Colors.black26,
        ),
        Spaces.vertical20,
        _TodaysTasks(
          animate: ticker > 3,
        ),
        Spaces.vertical60,
        _TasksPercentages(
          animate: ticker > 5,
        ),
        Spaces.vertical40,
        _CurrentStats(
          animate: ticker > 3,
        ),
        const HorzDivider(),
        BackgroundText(
          title: 'Settings',
          color: Prefs.isDarkMode ? Colors.white30 : Colors.black12,
        ),
        _Settings(
          animate: ticker > 3,
        ),
        Spaces.vertical60,
        const _HomeScreenOptions(),
        Spaces.vertical60,
        const _RateUsButton(),
        Spaces.vertical50
      ],
    );
  }
}

class _HomeScreenOptions extends StatefulWidget {
  const _HomeScreenOptions({
    Key? key,
  }) : super(key: key);

  @override
  State<_HomeScreenOptions> createState() => _HomeScreenOptionsState();
}

class _HomeScreenOptionsState extends State<_HomeScreenOptions> {
  bool showOptions = applyHomeScreenImage;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return PhysicalModel(
      color: Colors.transparent,
      shadowColor: colorWatch.shadow,
      elevation: ELEVATION,
      borderRadius: BORDER_RADIUS,
      child: AnimatedContainer(
        duration: Durations.d300,
        curve: Curves.easeOut,
        width: double.infinity,
        height: applyHomeScreenImage ? 290 : 154,
        padding: _innerPadding,
        margin: MARGIN,
        decoration: Decorations.decoratedContainer_alt(colorWatch.onBackground),
        onEnd: () {
          setState(() {
            showOptions = !showOptions;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home Screen',
              style: TextStyles.b1(colorWatch.foreground),
            ),
            Spaces.vertical20,
            const _SwicthWithHeader(title: 'Background Image'),
            if (applyHomeScreenImage && showOptions)
              AnimatedOpacity(
                  duration: Durations.d600,
                  opacity: showOptions ? 1 : 0,
                  child: const HorzDividerMini()),
            if (applyHomeScreenImage && showOptions) Spaces.vertical20,
            if (applyHomeScreenImage && showOptions)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _ToggleButton(
                    icon: Icons.blur_on,
                    label: 'Blur',
                    comparator: blurHomeScreenImage,
                    onPressed: () {
                      setState(
                          () => blurHomeScreenImage = !blurHomeScreenImage);
                    },
                  ),
                  _ToggleButton(
                    icon: Icons.gradient,
                    label: 'Gradient',
                    comparator: gradientHomeScreenImage,
                    onPressed: () {
                      setState(() =>
                          gradientHomeScreenImage = !gradientHomeScreenImage);
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.comparator,
      required this.label})
      : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final bool comparator;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            width: 50,
            height: 50,
            duration: Durations.d300,
            curve: Curves.ease,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                    color: comparator ? Colors.pink : Colors.blueGrey.shade800,
                    width: 2)),
            child: Icon(
              icon,
              size: comparator ? 28 : 22,
              color: comparator
                  ? Colors.pink
                  : const Color.fromRGBO(55, 71, 79, 0.5),
            ),
          ),
        ),
        Spaces.vertical10,
        Text(
          label,
          style: TextStyles.h8(
              comparator ? Colors.pink : Colors.blueGrey.shade800),
        )
      ],
    );
  }
}

class _CurrentStats extends StatelessWidget {
  const _CurrentStats({Key? key, required this.animate}) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final int numberOfTables = context.watch<Table_pr>().tables.length;
    final int numberOfReminders = context.watch<Reminder_pr>().reminders.length;
    final int workLoadHours = context
        .watch<Table_pr>()
        .tables[Prefs.homeTable]
        .dayLoad(DateTime.now().weekday - 1)
        .round();

    return AnimatedSlide(
      duration: Durations.d500,
      curve: Curves.easeOutQuint,
      offset: Offset(animate ? 0 : 0.5, 0),
      child: AnimatedOpacity(
        opacity: animate ? 1 : 0,
        duration: Durations.d800,
        child: PhysicalModel(
          color: Colors.transparent,
          shadowColor: Colors.blueGrey.shade200,
          elevation: ELEVATION,
          borderRadius: BORDER_RADIUS,
          child: Container(
            width: double.infinity,
            height: 160,
            margin: MARGIN,
            decoration: Decorations.decoratedContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NumberWithLabel(
                  label: 'No. of Tables',
                  number: numberOfTables,
                ),
                const VertDividerMini(),
                _NumberWithLabel(
                  label: 'Today\'s load (hrs)',
                  number: workLoadHours,
                ),
                const VertDividerMini(),
                _NumberWithLabel(
                  label: 'Reminders',
                  number: numberOfReminders,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberWithLabel extends StatelessWidget {
  const _NumberWithLabel({Key? key, required this.label, required this.number})
      : super(key: key);

  final String label;
  final int number;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: [
        TextSpan(
            text: '$number\n',
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'VarelaRound',
                fontSize: 56,
                fontWeight: FontWeight.w900)),
        TextSpan(
          text: label,
          style: TextStyles.h8(Colors.blueGrey.shade800),
        )
      ]),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _TasksPercentages extends StatelessWidget {
  const _TasksPercentages({Key? key, required this.animate}) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ProgressIndicator(
          content: '92.78',
          label: 'COMPLETED',
          animate: animate,
        ),
        _ProgressIndicator(
          content: '7.22',
          label: 'LEFT',
          animate: animate,
        )
      ],
    );
  }
}

class _Settings extends StatelessWidget {
  const _Settings({Key? key, required this.animate}) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return AnimatedOpacity(
      duration: Durations.d600,
      opacity: animate ? 1 : 0,
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: colorWatch.shadow,
        elevation: ELEVATION,
        borderRadius: BORDER_RADIUS,
        child: AnimatedContainer(
          duration: Durations.d300,
          curve: Curves.easeOut,
          width: double.infinity,
          margin: MARGIN,
          decoration:
              Decorations.decoratedContainer_alt(colorWatch.onBackground),
          padding: _innerPadding,
          child: Column(
            children: const [
              _SwicthWithHeader(
                title: 'Dark Mode',
              ),
              _SwicthWithHeader(
                title: 'Auto-dispose Reminders',
              ),
              HorzDividerMini(),
              _SwicthWithHeader(
                title: 'Notifications',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

class _TodaysTasks extends StatefulWidget {
  const _TodaysTasks({required this.animate});

  final bool animate;

  @override
  State<_TodaysTasks> createState() => _TodaysTasksState();
}

class _TodaysTasksState extends State<_TodaysTasks> {
  List<String> _tasksCompleted = [];
  List<String> _tasksLeft = [];

  late final Table_pr tableReader;

  @override
  void initState() {
    tableReader = context.read<Table_pr>();
    fillTaskLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return AnimatedSlide(
      duration: Durations.d500,
      curve: Curves.easeOutQuint,
      offset: Offset(widget.animate ? 0 : 0.5, 0),
      child: AnimatedOpacity(
        duration: Durations.d800,
        opacity: widget.animate ? 1 : 0,
        child: PhysicalModel(
          color: Colors.transparent,
          shadowColor: colorWatch.shadow,
          elevation: ELEVATION,
          borderRadius: BORDER_RADIUS,
          child: AnimatedContainer(
              duration: Durations.d300,
              curve: Curves.easeOut,
              width: double.infinity,
              padding: _innerPadding,
              margin: MARGIN,
              decoration:
                  Decorations.decoratedContainer_alt(colorWatch.onBackground),
              child: Column(
                children: [
                  _TaskTitles(
                      header: 'Done',
                      tasks:
                          _tasksCompleted.isEmpty ? ['None'] : _tasksCompleted),
                  const HorzDividerMini(),
                  _TaskTitles(
                      header: 'Left',
                      tasks: _tasksLeft.isEmpty ? ['None'] : _tasksLeft),
                ],
              )),
        ),
      ),
    );
  }

  void fillTaskLists() {
    final List<TimeSlot> todaysTimeSlots = tableReader
        .tables[Prefs.homeTable].timeSlots[DateTime.now().weekday - 1];

    for (int i = 0; i < todaysTimeSlots.length; i++) {
      if (TimeOfDay.now() > todaysTimeSlots[i].endTime) {
        _tasksCompleted.add(todaysTimeSlots[i].title);
      } else {
        _tasksLeft.add(todaysTimeSlots[i].title);
      }
    }
  }
}

class _TaskTitles extends StatelessWidget {
  const _TaskTitles({
    Key? key,
    required this.header,
    required List<String> tasks,
  })  : _tasksCompleted = tasks,
        super(key: key);

  final String header;
  final List<String> _tasksCompleted;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return Row(
      children: [
        Text(
          '$header:   ',
          style: TextStyles.b1(colorWatch.foreground),
        ),
        Wrap(
            children: _tasksCompleted
                .map((title) => Text(
                      '$title   ',
                      style:
                          TextStyles.h4(colorWatch.foreground.withOpacity(0.7)),
                    ))
                .toList())
      ],
    );
  }
}

class _RateUsButton extends StatelessWidget {
  const _RateUsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
          onPressed: () {
            //TODO: push to playStore
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              elevation: 6,
              fixedSize: const Size(160, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Text(
            'Rate Us',
            style: TextStyles.b1(Colors.white),
          )),
    );
  }
}

class _SwicthWithHeader extends StatefulWidget {
  const _SwicthWithHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  State<_SwicthWithHeader> createState() => _SwicthWithHeaderState();
}

class _SwicthWithHeaderState extends State<_SwicthWithHeader> {
  late final Color_pr colorReader;

  @override
  void initState() {
    colorReader = context.read<Color_pr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();

    return Row(
      children: [
        Text(
          widget.title,
          style: TextStyles.b2(colorWatch.foreground),
        ),
        const Spacer(),
        Switch(
            thumbColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.pink.shade300;
              }
              return colorWatch.onBackground.withOpacity(0.75);
            }),
            trackColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.pink.withOpacity(0.3);
              }
              return Prefs.isDarkMode ? Colors.white38 : Colors.black26;
            }),
            value: widget.title[0] == 'N'
                ? allowNotifications
                : widget.title[0] == 'D'
                    ? Prefs.isDarkMode
                    : widget.title[0] == 'B'
                        ? applyHomeScreenImage
                        : autoDisposeReminders,
            onChanged: (value) => setState(() => widget.title[0] == 'N'
                ? allowNotifications = value
                : widget.title[0] == 'D'
                    ? value
                        ? colorReader.toDark()
                        : colorReader.toLight()
                    : widget.title[0] == 'B'
                        ? applyHomeScreenImage = value
                        : autoDisposeReminders = value))
      ],
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator(
      {Key? key,
      required this.content,
      required this.label,
      required this.animate})
      : super(key: key);

  final String content;
  final String label;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();
    final w = Utils.screenWidthPercentage(context, 1);

    return SizedBox(
      height: w * 0.3 + 40,
      width: w * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Durations.d500,
            curve: Curves.easeOutQuint,
            width: animate ? w * 0.3 : 0,
            height: animate ? w * 0.3 : 0,
            alignment: Alignment.center,
            decoration: Decorations.progressIndicator(
                Prefs.isDarkMode ? Colors.white70 : Colors.black45),
            child: Text(
              '$content%',
              style: TextStyles.h4(colorWatch.onBackground),
            ),
          ),
          Spaces.vertical10,
          AnimatedOpacity(
            duration: Durations.d1000,
            opacity: animate ? 1 : 0,
            curve: Curves.decelerate,
            child: Text(
              label,
              style: TextStyles.h8(colorWatch.foreground),
            ),
          )
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _UserInfo extends StatelessWidget {
  const _UserInfo({Key? key, required this.animate}) : super(key: key);

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final Color_pr colorWatch = context.watch<Color_pr>();
    final w = Utils.screenWidthPercentage(context, 1);

    return AnimatedOpacity(
      duration: Durations.d600,
      opacity: animate ? 1 : 0,
      child: AnimatedSlide(
        offset: Offset(0, animate ? 0 : -0.3),
        duration: Durations.d500,
        curve: Curves.easeOutQuint,
        child: PhysicalModel(
          color: Colors.transparent,
          shadowColor: colorWatch.shadow,
          elevation: ELEVATION,
          borderRadius: BORDER_RADIUS,
          child: Container(
            width: w - 40,
            padding: _innerPadding,
            margin: MARGIN,
            decoration:
                Decorations.decoratedContainer_alt(colorWatch.onBackground),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Prefs.username,
                    style: TextStyles.bk2(color: Colors.pink.withOpacity(1))),
                Spaces.vertical20,
                Text(
                  'User description',
                  style: TextStyles.h4(colorWatch.foreground),
                ),
                const HorzDividerMini(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(children: [
                      TextSpan(
                        text: 'Account Created:\n',
                        style: TextStyles.b2(colorWatch.foreground),
                      ),
                      TextSpan(
                          text: DateFormat.yMMMd().format(Prefs.dateCreated),
                          style: TextStyles.b3(colorWatch.foreground))
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
