
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

extension DateTimeExtenstion on DateTime{

  bool operator >(DateTime dt){

    if(this.year < dt.year){
      return false;
    }
    if(this.year > dt.year){
      return true;
    }
    if(this.month < dt.month){
      return false;
    }
    if(this.month > dt.month){
      return true;
    }
    if(this.day < dt.day){
      return false;
    }
    if(this.day > dt.day){
      return true;
    }
    if(this.hour < dt.hour){
      return false;
    }
    if(this.hour > dt.hour){
      return true;
    }
    if(this.minute < dt.minute){
      return false;
    }
    if(this.minute > dt.minute){
      return true;
    }
    return false;
  }
}