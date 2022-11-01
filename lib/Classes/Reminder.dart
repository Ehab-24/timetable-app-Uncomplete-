
// ignore_for_file: unnecessary_this

import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Miscellaneous/ExtensionMethods.dart';

class Reminder{

  int? id;
  DateTime dateTime;
  String title;
  String description;

  static Reminder get zero =>
    Reminder(
      dateTime: DateTime.now(),
      title: '',
      description: ''
    );

  Reminder({
    required this.dateTime,
    required this.title,
    this.id,
    this.description = ''
  });

  Reminder copyWith({
    int? id,
    String? title,
    DateTime? dateTime,
    String? description,
  }) => Reminder(
    description: description ?? this.description,
    dateTime: dateTime ?? this.dateTime,
    title: title ?? this.title,
    id: id?? this.id,
  );

  bool isSameAs(Reminder other){
    return this.title == other.title
    && this.dateTime.isSameMinuteAs(other.dateTime)
    && this.description == other.description;
  }

  Map<String, Object?> toJson(){
    return {
      ReminderFields.dateTime: dateTime.toIso8601String(),
      ReminderFields.description: description,
      ReminderFields.title: title,
      ReminderFields.id: id
    };
  }

  static sortAll(List<Reminder> reminders){
    
    bool bubbling = true; int loops = 0;
    while(bubbling){
      bubbling = false;
      for(int i = 0; i + 1 < reminders.length - loops; i++){
        if(reminders[i].dateTime.isAfter(reminders[i + 1].dateTime)){
          Reminder holder = reminders[i];
          reminders[i] = reminders[i + 1];
          reminders[i + 1] = holder;

          bubbling = true;
        }
      }
      loops++;
    }
  }

  static Reminder fromJson(Map<String, Object?> json) =>
    Reminder(
      title: json[ReminderFields.title] as String,
      dateTime: DateTime.parse(json[ReminderFields.dateTime] as String),
      description: json[ReminderFields.description] as String,
      id: json[ReminderFields.id] as int
    );

  bool operator > (final Reminder rem){
    return this.dateTime > rem.dateTime;
  }
}