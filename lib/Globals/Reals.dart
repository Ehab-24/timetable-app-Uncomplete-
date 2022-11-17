
// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:timetable_app/Classes/FocusedMenuItem.dart';
import 'package:timetable_app/Globals/Utils.dart';

import '../Classes/Reminder.dart';
import '../Classes/TimeTable.dart';
import '../Databases/ServicesPref.dart';
import 'Providers.dart';



int currentTableIndex = 0;
String linearFlowFab = 'linear-flow-fab';

const EdgeInsets MARGIN = EdgeInsets.symmetric(horizontal: 4);
BorderRadius BORDER_RADIUS = BorderRadius.circular(80);
const double ELEVATION = 20;

TimePickerThemeData _timePickerTheme(Color_pr colorWatch) => TimePickerThemeData(
  
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  ),  
  backgroundColor: colorWatch.onBackground,
  hourMinuteShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
  hourMinuteColor: MaterialStateColor.resolveWith(
    (states) => colorWatch.background),
  hourMinuteTextColor: MaterialStateColor.resolveWith(
      (states) => colorWatch.foreground),

  dialHandColor: Prefs.isDarkMode? Utils.lighten(colorWatch.background): Utils.darken(colorWatch.background),
  dialBackgroundColor: colorWatch.background,
  
  hourMinuteTextStyle: const TextStyle(fontFamily: 'VarelaRound', fontSize: 20, fontWeight: FontWeight.bold),
  dayPeriodTextStyle: const TextStyle(fontFamily: 'VarelaRound', fontSize: 12, fontWeight: FontWeight.bold),
  helpTextStyle:
    const TextStyle(fontFamily: 'VarelaRound', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.pink),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    contentPadding: EdgeInsets.all(0),
  ),
  dialTextColor: MaterialStateColor.resolveWith(
      (states) => states.contains(MaterialState.selected) ? Colors.pink : colorWatch.foreground),
  entryModeIconColor: Colors.pink,
);
//

TextButtonThemeData _textButtonTheme(Color color) => TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8)
    )
  )
);
//
ElevatedButtonThemeData _elevatedButtonTheme(Color_pr colorWatch) => ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pink,
    foregroundColor: colorWatch.onBackground,
    fixedSize: const Size.fromWidth(100),
    padding: const EdgeInsets.symmetric(vertical: 10),
    shadowColor: colorWatch.shadow_alt,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50)
    ),
  )
);
//
OutlinedButtonThemeData _outlinedButtonTheme(Color_pr colorWatch) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: colorWatch.foreground, width: 0.5),
      foregroundColor: colorWatch.foreground
    )
  );
}
//
ThemeData themeData(Color_pr colorWatch) {
  return ThemeData(
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.grey,
    ),
    timePickerTheme: _timePickerTheme(colorWatch),
    textButtonTheme: _textButtonTheme(colorWatch.foreground),
    elevatedButtonTheme: _elevatedButtonTheme(colorWatch),
    outlinedButtonTheme: _outlinedButtonTheme(colorWatch)
  );
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////


List<String> days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

List<FocusedMenuListItem> focusedMenuItems = [
  FocusedMenuListItem(icon: const Icon(Icons.home), title: 'Set as home'),
  FocusedMenuListItem(icon: const Icon(Icons.stacked_bar_chart), title: 'Statistics'),
  FocusedMenuListItem(icon: const Icon(Icons.edit_note), title: 'Edit Table', ),
  FocusedMenuListItem(icon: const Icon(Icons.delete), title: 'Clear Table',),
  FocusedMenuListItem(icon: const Icon(Icons.delete_forever), title: 'Delete Table'),
  FocusedMenuListItem(icon: const Icon(Icons.add_box), title: 'Add Slot', ),
];

late List<TimeTable> timeTables;
late List<Reminder> reminders;