
import 'package:flutter/material.dart';

class Tables{

  static String timeTablesTable = 'TimeTablesTable';
  static String slotsTable = 'SlotsTable';

  static String timeTablesTableSchema = '''
  CREATE TABLE $timeTablesTable (
    ${TimeTableFields.title} ${DataTypes.string},
    ${TimeTableFields.id} ${DataTypes.id}
  )
  ''';

  static String slotsTableSchema = '''
  CREATE TABLE $slotsTable (
    ${TimeSlotFields.id} ${DataTypes.id},
    ${TimeSlotFields.day} ${DataTypes.int},
    ${TimeSlotFields.title} ${DataTypes.string},
    ${TimeSlotFields.subtitle} ${DataTypes.string},
    ${TimeSlotFields.venue} ${DataTypes.string},
    ${TimeSlotFields.startTime} ${DataTypes.string},
    ${TimeSlotFields.endTime} ${DataTypes.string},
    ${TimeSlotFields.parentId} ${DataTypes.int}
  )
  ''';
}

class DataTypes{
  static String
    int = 'INTEGER NOT NULL',
    string = 'TEXT NOT NULL',
    bool = 'BOOLEAN NOT NULL',
    id = 'INTEGER PRIMARY KEY AUTOINCREMENT';
}

class TimeTableFields{
  static String 
    title = 'title',
    // color = 'color',
    id = '_id';
}

class TimeSlotFields{
  static String
    title = 'title',
    subtitle = 'subtitle',
    venue = 'venue',
    endTime = 'endTime',
    startTime = 'startTime',
    day = 'day',
    parentId = 'parentId',
    id = '_id';
}

class Screens{

  static const int home = 0;
  static const int mytables = 1;
  static const int web = 2;
  static const int schedule = 3;
  static const int reminders = 4;
}

class Durations{

  static const Duration d1000 = Duration(seconds: 1);
  static const Duration d800 = Duration(milliseconds: 800);
  static const Duration d600 = Duration(milliseconds: 600);
  static const Duration d500 = Duration(milliseconds: 500);
  static const Duration d300 = Duration(milliseconds: 300);
  static const Duration d200 = Duration(milliseconds: 200);
  static const Duration d150 = Duration(milliseconds: 150);
  static const Duration d100 = Duration(milliseconds: 100);
  static const Duration d80 = Duration(milliseconds: 80);
}

class Spaces{

  static const vertical10 =  SizedBox(height: 10);
  static const vertical20 =  SizedBox(height: 20);
  static const vertical30 =  SizedBox(height: 30);
  static const vertical40 =  SizedBox(height: 40);
  static const vertical60 =  SizedBox(height: 60);
  static const vertical80 =  SizedBox(height: 80);
  static const vertical120 =  SizedBox(height: 120);
  
  static const horizontal10 =  SizedBox(width: 10);
  static const horizontal20 =  SizedBox(width: 20);
  static const horizontal30 =  SizedBox(width: 30);
  static const horizontal40 =  SizedBox(width: 40);
  static const horizontal60 =  SizedBox(width: 60);
  static const horizontal80 =  SizedBox(width: 80);
  static const horizontal120 =  SizedBox(width: 120);

  static SizedBox vertical(double h) => SizedBox(height: h,);
  static SizedBox horizontal(double w) => SizedBox(width: w,);
}