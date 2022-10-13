
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:timetable_app/Classes/TimeSlot.dart';
import 'package:timetable_app/Classes/TimeTable.dart';
import 'package:timetable_app/Globals/enums.dart';


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

class Table_pr extends ChangeNotifier{


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Fields. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/
  
  List<TimeTable> tables;  

  Table_pr(this.tables);


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods for Time Slots. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

  void addSlot(TimeSlot ts){
    
    int index = indexOfParent(ts.parentId);

    if(ts.startTime.hour < tables[index].minTime.hour
    || ts.startTime.hour == tables[index].minTime.hour && ts.startTime.minute < tables[index].minTime.minute){
      tables[index].minTime = ts.startTime;
    }
    else if(ts.endTime.hour > tables[index].maxTime.hour
    || ts.endTime.hour == tables[index].maxTime.hour && ts.endTime.minute > tables[index].maxTime.minute){
      tables[index].maxTime = ts.endTime;
    }

    tables[index].add(ts);
    notifyListeners();
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

  void removeTable(TimeTable timeTable){
    
    tables.remove(timeTable);    
    notifyListeners();
  }

  void validate(TimeSlot ts){
    
    int index = indexOfParent(ts.parentId);
    tables[index].validate(ts);

    //No need to notify listeners here.
  }

  void reformList(TimeSlot timeSlot, int prevDay){
    
    if(timeSlot.day == prevDay){
      return;
    }

    int index = indexOfParent(timeSlot.parentId);
    
    tables[index].timeSlots[prevDay].remove(timeSlot);
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