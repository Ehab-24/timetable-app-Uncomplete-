
import 'package:flutter/material.dart';
import 'package:timetable_app/Classes/FocusedMenuItem.dart';

import '../Classes/Reminder.dart';
import '../Classes/TimeTable.dart';


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

int currentTableIndex = 0;
String linearFlowFab = 'linear-flow-fab';

EdgeInsets MARGIN = const EdgeInsets.symmetric(horizontal: 4);
BorderRadius BORDER_RADIUS = BorderRadius.circular(80);
const double ELEVATION = 20;

////////////////////////////////////////////////////////////////////////////////////////////////////////////

late List<TimeTable> timeTables;
late List<Reminder> reminders;