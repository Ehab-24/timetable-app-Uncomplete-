
// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

extension TimeExtension on TimeOfDay{

  bool operator <(TimeOfDay t){

    if(hour < t.hour){
      return true;
    }
    else if(hour == t.hour && minute < t.minute){
      return true;
    }
    return false;
  }

  bool operator >(TimeOfDay t){

    if(hour > t.hour){
      return true;
    }
    else if(hour == t.hour && minute > t.minute){
      return true;
    }
    return false;
  }
}

extension StringEx on String{

  TimeOfDay toTimeOfDay(){
    String s = this.substring(10, this.length - 1);
    return TimeOfDay(hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
  }
}