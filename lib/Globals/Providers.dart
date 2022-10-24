
// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:timetable_app/Classes/Reminder.dart';
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

    if(reminders.isEmpty){
      reminders.add(rem);
      return;
    }

    //Add a place holder.
    reminders.add(Reminder.zero);

    //Find proper index to keep the array sorted.
    int index = searchInsertionIndex(rem);

    //Shift elements to the right.
    for(int i = reminders.length - 1; i > index; i--){
      reminders[i] = reminders[i-1];
    }
    reminders[index] = rem;

    notifyListeners();
  }

  void update(Reminder rem){
    for(int i = 0; i < reminders.length; i++){
      if(reminders[i].id == rem.id){
        reminders[i] = rem;
        notifyListeners();
        return;
      }
    }
    throw('Reminder NOT FOUND! - id: ${rem.id}');
  }

  void remove(Reminder rem){

    int index = searchRemovalIndex(rem);
    reminders.removeAt(index);

    notifyListeners();    
  }


/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ UTILITY ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

  int searchInsertionIndex(Reminder rem){
  
    for(int i = 0; i < reminders.length; i++){
      if(rem > reminders[i]){
        return i;
      }
    }
    return reminders.length - 1;
  }

  int searchRemovalIndex(Reminder rem){
   
    int l = 0, r = reminders.length - 1;

    if(reminders[l] == rem){
      return l;
    }
    if(reminders[r] == rem){
      return r;
    }

    int mid;
    while(l < r){

      mid = ((l + r) / 2).floor();

      if(reminders[mid] > rem){
        r = mid;
      }
      else if(rem > reminders[mid]){
        l = mid;
      }
      else{
        return mid;
      }
    }
    return -1;
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

  void validateTitle(String title){
    for(int i = 0; i < tables.length; i++){
      if(tables[i].title == title){
        throw('$title already exists');
      }
    }
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