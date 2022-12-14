
// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:timetable_app/Miscellaneous/ExtensionMethods.dart';

import '../Globals/enums.dart';

class TimeSlot{

  int? id;
  int day, parentId;
  String title, subtitle;
  TimeOfDay startTime, endTime;

  TimeSlot({
    this.id,
    required this.title,
    required this.subtitle,
    required this.day,
    required this.parentId,
    required this.startTime,
    required this.endTime,
  });

  TimeSlot copyWith({
    int? id,
    int? day,
    int? parentId,
    String? title,
    String? subtitle,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  })
  => TimeSlot(
    id: id??this.id,
    day: day??this.day,
    parentId: parentId ?? this.parentId,
    title: title??this.title,
    subtitle: subtitle??this.subtitle,
    startTime:startTime??this.startTime,
    endTime:endTime??this.endTime,
  );

  bool isSameAs(TimeSlot ts){
    return this.title == ts.title
    && this.day == ts.day
    && this.startTime == ts.startTime
    && this.endTime == ts.endTime
    && this.subtitle == ts.subtitle;
  }
  
//Hours (as double) between start and end time of a time slot.
  double get span 
  => ((endTime.hour - startTime.hour)
      + (endTime.minute - startTime.minute) / 60);

//Expects 'endTime' to be chronologically after 'startTime'.
  static double gap(TimeOfDay startTime, TimeOfDay endTime)
  => ((endTime.hour - startTime.hour)
      + (endTime.minute - startTime.minute) / 60);

  static TimeSlot zero(int parentId, int day){
    
    return TimeSlot(
      day: day,
      title: '',
      subtitle: '',
      startTime: const TimeOfDay(hour: 12, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      parentId: parentId,
    );
  }

   Map<String, Object?> toJson() => {
      TimeSlotFields.id: id,
      TimeSlotFields.day: day,
      TimeSlotFields.title: title,
      TimeSlotFields.parentId: parentId,
      TimeSlotFields.subtitle: subtitle,
      TimeSlotFields.startTime: startTime.toString(),
      TimeSlotFields.endTime: endTime.toString(),
    };

  static TimeSlot fromJson(Map<String, Object?> json) =>
    TimeSlot(
      id: json[TimeSlotFields.id] as int?,
      title: json[TimeSlotFields.title] as String, 
      day: json[TimeSlotFields.day] as int,
      endTime: (json[TimeSlotFields.endTime] as String).toTimeOfDay(),
      startTime: (json[TimeSlotFields.startTime] as String).toTimeOfDay(),
      subtitle: json[TimeSlotFields.subtitle] as String,
      parentId: json[TimeSlotFields.parentId] as int,
    );   

  void validate(){
    if(startTime.hour == endTime.hour && startTime.minute == endTime.minute){
      throw 'Starting and ending time cannot be same.';
    }
    if(endTime.hour < startTime.hour){
      throw 'Ending time must be greater than starting time.';
    }
    if(endTime.hour == startTime.hour && endTime.minute < startTime.minute){
      throw 'Ending time must be greater than starting time.';
    }
  }

  bool overruns(TimeOfDay time){
    if(time < endTime && time > startTime){
      return true;
    }
    if(time == startTime || time == endTime){
      return true;
    }
    return false;
  }
}