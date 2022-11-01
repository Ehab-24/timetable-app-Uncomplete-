
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:timetable_app/Classes/Reminder.dart';
import 'package:timetable_app/Classes/TimeSlot.dart';
import 'package:timetable_app/Classes/TimeTable.dart';
import 'package:timetable_app/Databases/ServicesPref.dart';
import 'package:timetable_app/Globals/ColorsAndGradients.dart';
import 'package:timetable_app/Globals/Reals.dart';
import 'package:timetable_app/Globals/enums.dart';


class NewReminder_pr extends ChangeNotifier{

  NewReminder_pr();

  Reminder reminder = Reminder.zero;

  void setDateTime(DateTime dt){
    reminder.dateTime = dt;
    notifyListeners();
  }
  void setTitle(String title){
    reminder.title = title;
    notifyListeners();
  }
  void setDesc(String desc){
    reminder.description = desc;
    notifyListeners();
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////

class NewSlot_pr extends ChangeNotifier{

  NewSlot_pr();

  TimeSlot timeSlot = TimeSlot.zero(-1,0);

  void setDay(int day){
    timeSlot.day = day;
    notifyListeners();
  }
  void setVenue(String venue){
    timeSlot.venue = venue;
    notifyListeners();
  }
  void setStartTime(TimeOfDay td){
    timeSlot.startTime = td;
    notifyListeners();
  }
  void setEndTime(TimeOfDay td){
    timeSlot.endTime = td;
    notifyListeners();
  }
  void setTitle(String title){
    timeSlot.title = title;
    notifyListeners();
  }
  void setSubtitle(String sutitle){
    timeSlot.subtitle = sutitle;
    notifyListeners();
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Day_pr extends ChangeNotifier{

  int selectedDay;

  Day_pr(
    this.selectedDay,
  );

  void setDay(int newDay){
    selectedDay = newDay;
    notifyListeners();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

class Screen_pr extends ChangeNotifier{

  int currentScreen = Screens.home;

  void setScreen(int screen){
    currentScreen = screen;
    notifyListeners();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////


class Ticker_pr extends ChangeNotifier{

  int value = 0;

  void set(int val){
    value = val;
    notifyListeners();
  }

  void increment(){
    value++;
    notifyListeners();
  }

  void reset(){
    value = 0;
    notifyListeners();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////


class Reminder_pr extends ChangeNotifier{


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Fields. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/
  
  List<Reminder> reminders;

  Reminder_pr(this.reminders);


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods for Reminders. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

  void add(Reminder rem){

    reminders.add(rem);
    sort();

    notifyListeners();
  }

  void update(Reminder rem){
    for(int i = 0; i < reminders.length; i++){
      if(reminders[i].id == rem.id){
        
        reminders[i] = rem;
        sort();

        notifyListeners();
        return;
      }
    }
    throw('Reminder NOT FOUND! - id: ${rem.id}');
  }

  void remove(Reminder rem){

    reminders.remove(rem);
    sort();

    notifyListeners();    
  }

  void sort(){
    Reminder.sortAll(reminders);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

class Table_pr extends ChangeNotifier{


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Fields. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/
  
  List<TimeTable> tables;  

  Table_pr(this.tables);


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods for Time Slots. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

  void addSlot(TimeSlot ts){
    
    int index = indexOfParent(ts.parentId);

    tables[index].add(ts);
    notifyListeners();
  }

  void updateSlot(TimeSlot ts, int previousDay){

    int index = tables[currentTableIndex].timeSlots[previousDay].indexWhere((slot) => slot.id == ts.id);
    tables[currentTableIndex].timeSlots[previousDay][index] = ts;

    //No need to notify listeners here.
  }

  void removeSlot(TimeSlot ts){

    int index = indexOfParent(ts.parentId);

    tables[index].remove(ts);

    notifyListeners();
  }


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods for Time Tables. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/
  
  void addTable(TimeTable tt){
    tables.add(tt);
    notifyListeners();
  }

  void updateTable(int index, String title){
    tables[index].title = title;
    notifyListeners();
  }

  void removeTable(int id){
    
    tables.removeWhere((table) => table.id == id);    
    notifyListeners();
  }

  void clearTable(int id){

    int index = 0;
    while(tables[index].id != id){
      index++;
    }

    tables[index].clear();
    notifyListeners();
  }

  void validate(TimeSlot ts){
    
    int index = indexOfParent(ts.parentId);
    tables[index].validate(ts);

    //No need to notify listeners here.
  }

  void validateTitle(String title){
    for(int i = 0; i < tables.length; i++){
      if(tables[i].title == title){
        throw('$title already exists');
      }
    }
  }

  void reformList(TimeSlot timeSlot, int previousDay){
    
    if(timeSlot.day == previousDay){
      return;
    }
    int index = indexOfParent(timeSlot.parentId);
    tables[index].timeSlots[previousDay].removeWhere((slot) => slot.startTime == timeSlot.startTime);
    tables[index].add(timeSlot);

    //No need to notify listeners here.
  }

  //Sort a single list/day of a time table.
  void sort(int day, int parent){
    int index = indexOfParent(parent);
    tables[index].sort(day);
    notifyListeners();
  }


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ UTILITY ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

  int indexOfParent(int id){
    
    int index = 0;
    while(index < tables.length){
      if(tables[index].id == id){
        return index;
      }
      index++;
    }
    throw 'Parent TimeTable (_id: $id) NOT FOUND!';
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

class Color_pr extends ChangeNotifier{
  
  Color_pr({
    required this.background,
    required this.onBackground,
    required this.foreground,
    required this.shadow,
    required this.shadow_alt,
    required this.splash
  });

  Color background, onBackground, foreground, shadow_alt, shadow, splash;


  void toLight(){
    background = backgroundC;
    onBackground = onBackgroundC;
    foreground = foregroundC;
    shadow = shadowC;
    shadow_alt = shadow_altC;
    splash = splashC;
    
    Prefs.setDarkMode(false);

    notifyListeners();
  }
  void toDark(){
    background = backgroundDarkC;
    onBackground = onBackgroundDarkC;
    foreground = foregroundDarkC;
    shadow = shadowDarkC;
    shadow_alt = shadow_altDarkC;
    splash = splashDarkC;
    
    Prefs.setDarkMode(true);

    notifyListeners();
  }
}