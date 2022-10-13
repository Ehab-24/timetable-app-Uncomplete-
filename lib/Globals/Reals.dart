
import 'package:flutter/material.dart';
import 'package:timetable_app/Classes/FocusedMenuItem.dart';
import 'package:timetable_app/Globals/enums.dart';

// const int INT_MAX = 9223372036854775807;

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
  FocusedMenuListItem(icon: const Icon(Icons.stacked_bar_chart), title: 'Statistics'),
  FocusedMenuListItem(icon: const Icon(Icons.upload), title: 'Upload', ),
  FocusedMenuListItem(icon: const Icon(Icons.delete), title: 'Clear Table',),
  FocusedMenuListItem(icon: const Icon(Icons.delete_forever), title: 'Delete Table'),
  FocusedMenuListItem(icon: const Icon(Icons.edit), title: 'Edit Table', ),
  FocusedMenuListItem(icon: const Icon(Icons.add_circle_outline), title: 'Add Reminder', ),
  FocusedMenuListItem(icon: const Icon(Icons.add_box_outlined), title: 'Add Slot', ),
];

int currentTableId = -1;
String linearFlowFab = 'linear-flow-fab';