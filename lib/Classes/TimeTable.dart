
// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:timetable_app/Classes/TimeSlot.dart';
import 'package:timetable_app/Globals/enums.dart';
import 'package:timetable_app/Miscellaneous/ExtansionMethods.dart';

import '../Globals/Reals.dart';


class TimeTable{

  int? id;
  // int color;
  String title;
  TimeOfDay minTime = const TimeOfDay(hour: 12, minute: 0),
            maxTime = const TimeOfDay(hour: 12, minute: 0);

  //Each list represents a day of week.
  List<List<TimeSlot>> timeSlots = List.generate(7, (index) => []);

  double get dayLoadAvg =>
    weekLoad / 7;
    
  double get dayLoadBusinessAvg =>
    weekLoad / 5;

  double get maxLoad {
    double max = 0.01;
    for(int i = 0; i < timeSlots.length; i++){
      double load = dayLoad(i);
      if(load > max){
        max = load;
      }
    }
    return max;
  }

  double dayLoad(int day) {
    
    int length = timeSlots[day].length;
    double sum = 0;
    
    for(int i = 0; i < length; i++){
      sum += timeSlots[day][i].span;
    }
    return sum;
  }

  double get weekLoad{
    
    double sum = 0;
    for(int i = 0; i < timeSlots.length; i++){
      sum += dayLoad(i);
    }
    return sum;
  }

  //Expects current day.
  TimeSlot? currentSlot(int day) {

    List<TimeSlot>list = timeSlots[day];
    for(int i = 0; i < list.length; i++){
      if(list[i].overruns(TimeOfDay.now())){
        return list[i];
      }
    }
    return null;
  }

  //Expects current day.
  TimeSlot? nextSlot(int day){

    TimeSlot? _currentSlot = currentSlot(day);
    if(_currentSlot == null){
      return null;
    }

    int index = timeSlots[day].indexOf(_currentSlot);
    
    if(index + 1 < timeSlots[day].length){
      return timeSlots[day][index + 1];
    }
    return null;
  }

  TimeTable({
    this.id,
    // required this.color,
    required this.title,
  });

  TimeTable copyWith({
    String? title,
    int? id,
    int? color
  }) =>
    TimeTable(
      id: id ?? this.id,
      // color: color ?? this.color,
      title: title ?? this.title,
    );
  
  void add(TimeSlot slot){
    timeSlots[slot.day].add(slot);
  }

  void addAll(List<TimeSlot> slots){
    for(int i = 0; i < slots.length; i++){
      this.add(slots[i]);
    }
  }

  bool remove(TimeSlot ts){

    bool didRemove = timeSlots[ts.day].remove(ts);

    //If the removed time slot held 'minTime', we search for a new minTime. 
    if(ts.startTime == minTime){
      minTime = findMin();
    }
    //If the removed time slot held 'maxTime', we search for a new maxTime. 
    if(ts.endTime == maxTime){
      maxTime = findMax();
    }

    return didRemove;
  }

  void sort(int day){
  //This function sorts the List at day 'day'.
  //Since the number of timeSlots won't be large we can implement sort in O(n^2) time.
  //Also, bubble sort works better if the list is already sorted or close to sorted
  //(which will mostly be the case).
    int loops = 0;
    bool bubbling = true;
    
    while(bubbling){
     
      bubbling = false;

      for(int i = 0; i + 1 < timeSlots[day].length - loops; i++){
        
        if(timeSlots[day][i].startTime > timeSlots[day][i + 1].startTime){ 
          
          TimeSlot holder = timeSlots[day][i];
          timeSlots[day][i] = timeSlots[day][i+1];
          timeSlots[day][i+1] = holder;
          bubbling = true;
        } 
      }
      loops++;
    }
  }

  void sortTable(){
    for(int i = 0; i < timeSlots.length; i++){
    //Sort a single list at a time.
      sort(i);
    }
  }

  static void sortAll(List<TimeTable>tables){

    for(int i = 0; i < tables.length; i++){
    //Sort a single table at a time.
      tables[i].sortTable();
    }
  }

  //Validate for time clashes,
  //only required to check the list in which the slot was added.
  void validate(TimeSlot timeSlot){

    List<TimeSlot> list = timeSlots[timeSlot.day];
    if(list.isEmpty){
      return;
    }
    
    //Validate a single list/day
    for(int i = 0; i < list.length; i++){

      if(timeSlot.id != null && timeSlot.id == list[i].id){
        continue;
      }
      if(timeSlot.startTime < list[i].endTime && timeSlot.endTime > list[i].startTime){
        throw 'Clash with "${list[i].title}", which spans from ${list[i].startTime.hour}:${list[i].startTime.minute} to ${list[i].endTime.hour}:${list[i].endTime.minute} on ${days[list[i].day]}';
      }
    }
  }

  Map<String, Object?> toJson() => {
      TimeTableFields.id: id,
      TimeTableFields.title: title
    };

  static TimeTable fromJson(Map<String, Object?> json) =>
    TimeTable(
      // color: json[TimeTableFields.color] as int,
      title: json[TimeTableFields.title] as String,
      id: json[TimeTableFields.id] as int,
    );

/*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ UTILITY ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/
  
  TimeOfDay findMin(){

    TimeOfDay min = const TimeOfDay(hour: 23, minute: 59);
    
    for(int i = 0; i < timeSlots.length; i++){
      for(int j = 0; j < timeSlots[i].length; j++){
        if(timeSlots[i][j].startTime < min){
          min = timeSlots[i][j].startTime;
        }
      }
    }
    return min;
  }
  TimeOfDay findMax(){

    TimeOfDay max = const TimeOfDay(hour: 0, minute: 0);

    for(int i = 0; i < timeSlots.length; i++){
      for(int j = 0; j < timeSlots[i].length; j++){
        if(timeSlots[i][j].endTime > max){
          max = timeSlots[i][j].endTime;
        }
      }
    }
    return max;
  }
}