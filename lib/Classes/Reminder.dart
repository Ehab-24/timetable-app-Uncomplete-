
// ignore_for_file: unnecessary_this

import 'package:timetable_app/Miscellaneous/ExtansionMethods.dart';

class Reminder{

  DateTime dateTime;
  String title;
  String? subtitle;

  static Reminder get zero =>
    Reminder(
      dateTime: DateTime(DateTime.now().year - 5),
      title: 'Reminder'
    );

  Reminder({
    required this.dateTime,
    required this.title,
    this.subtitle
  });

  bool operator > (final Reminder rem){
    return this.dateTime > rem.dateTime;
  }
}