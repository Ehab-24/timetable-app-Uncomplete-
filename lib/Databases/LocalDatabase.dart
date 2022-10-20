
import 'package:sqflite/sqflite.dart';
import 'package:timetable_app/Classes/Reminder.dart';
import 'package:timetable_app/Classes/TimeSlot.dart';
import 'package:timetable_app/Classes/TimeTable.dart';

import '../Globals/enums.dart';

class LocalDatabase {

/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Fields ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

  static final instance = LocalDatabase._init();
  final String dbName = 'local_storage.db';

  Database? _database;

/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Database Initialization. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/
  
  LocalDatabase._init();

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(dbName, version: 8, onCreate: _onCreate);
  }
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(Tables.timeTablesTableSchema);
    await db.execute(Tables.slotsTableSchema);
    await db.execute(Tables.remindersTableSchema);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods for Reminders. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/


  Future<Reminder> addReminder(Reminder rem) async {
    
    final Database db = await instance.database;

    final int id  = await db.insert(Tables.remindersTable, rem.toJson());
    return rem.copyWith(id: id);
  }

  Future<List<Reminder>> readAllReminders() async {

    final Database db = await instance.database;

    var result = await db.rawQuery('''
  SELECT * FROM ${Tables.remindersTable}
  ''');

    return result.map((json) => Reminder.fromJson(json)).toList();
  }

  Future<int> updateReminder(Reminder rem) async {

    final Database db = await instance.database;

    return await db.update(
      Tables.remindersTable, 
      rem.toJson(),
      where: '${ReminderFields.id} = ?',
      whereArgs: [rem.id]
    );
  }

  Future<int> deleteReminder(int id) async {

    final Database db = await instance.database;

    return await db.rawDelete('''
  DELETE FROM ${Tables.remindersTable}
  WHERE ${ReminderFields.id} = ?
  ''', [id]
    );
  }

  Future<void> clearAllReminders() async {

    final Database db = await instance.database;

    await db.rawDelete('''
  DELETE FROM ${Tables.remindersTable}
  ''');
  }
  
/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods for Time Slots. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

  
  Future<TimeSlot> addSlot(TimeSlot timeSlot) async {

    final Database db = await instance.database;

    final int id = await db.insert(Tables.slotsTable, timeSlot.toJson());
    return timeSlot.copyWith(id: id);
  }

  Future<TimeSlot> readSlot(int id) async {

    final db = await instance.database;

    List<Map<String, Object?>> result = await db.rawQuery('''
  SELECT *
  FROM ${Tables.slotsTable}
  WHERE ${TimeSlotFields.id} = ?
  ''', [id]
    );

    if(result.isNotEmpty){
      return TimeSlot.fromJson(result.first);
    }
    throw 'Time slot (_id: $id) NOT FOUND!';
  }

  Future<List<TimeSlot>> readAllSlots(int parent) async {

    final db = await instance.database;
    final result = await db.rawQuery('''
  SELECT * FROM ${Tables.slotsTable} 
  WHERE ${TimeSlotFields.parentId} = ?
  ''', [parent]
    );

    return result.map((json) => TimeSlot.fromJson(json)).toList();
  }

  Future<int> updateSlot(TimeSlot timeSlot) async {

    final db = await instance.database;

    return db.update(
      Tables.slotsTable,
      timeSlot.toJson(),
      where: '${TimeSlotFields.id} = ?',
      whereArgs: [timeSlot.id], 
    );
  }

  Future<int> deleteSlot(int id) async {

    final db = await instance.database;

    return await db.rawDelete('''
  DELETE FROM ${Tables.slotsTable}
  WHERE ${TimeSlotFields.id} = ?
  ''', [id]
    );
  }
    
/* ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ Methods for Time Tables. ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */

  Future<TimeTable> addTimeTable(TimeTable table) async {

    final Database db = await instance.database;

    int id = await db.insert(
      Tables.timeTablesTable, 
      table.toJson()
    );
    return table.copyWith(id: id);
  }

  Future<int> updateTimeTable(TimeTable newTable) async {

    final db = await instance.database;

    return await db.update(
      Tables.timeTablesTable, 
      newTable.toJson(),
      where: '${TimeTableFields.id} = ?',
      whereArgs: [newTable.id],
    );
  }

  Future<int> deleteTimeTable(int id) async {

    final db = await instance.database;

    return await db.rawDelete('''
  DELETE FROM ${Tables.timeTablesTable}
  WHERE ${TimeTableFields.id} = ?
  ''',
  [id]
  );
  }

  Future<TimeTable> readTimeTable(int id) async {

    final db = await instance.database;

    List<Map<String, Object?>> result = await db.rawQuery('''
  SELECT *
  FROM ${Tables.timeTablesTable}
  WHERE ${TimeTableFields.id} = ?
  ''',
  [id]);

    if(result.isEmpty){
      throw 'Table _id NOT FOUND: $id';
    }

    List<TimeSlot>childSlots = await readAllSlots(id);
    TimeTable timeTable = TimeTable.fromJson(result.first);

    timeTable.addAll(childSlots);
    return timeTable;
  }

  Future<List<TimeTable>> readAllTimeTables() async{

    final db = await instance.database;

    final result = await db.rawQuery('''
  SELECT *
  FROM ${Tables.timeTablesTable}
  ''');

    List<TimeTable> timeTables = result.map((timeTable) 
      => TimeTable.fromJson(timeTable)).toList();

    List<TimeSlot>slots;
    for(int i = 0; i < timeTables.length; i++){
      //Read all time slots for one time table at a time.
      slots = await readAllSlots(timeTables[i].id!);
      timeTables[i].addAll(slots);
    }

    return timeTables;
  }

  Future<int> clearTimeTable(int parent) async{
    final db = await instance.database;

    return await db.rawDelete('''
  DELETE FROM ${Tables.slotsTable}
  WHERE ${TimeSlotFields.parentId} = ?
  ''',
  [parent]);
  }

  /*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ */

  Future<void> clearDatabase() async{

    final db = await instance.database;

    await db.rawDelete('''
  DELETE FROM ${Tables.slotsTable}
  ''');
    await db.rawDelete('''
  DELETE FROM ${Tables.timeTablesTable}
  ''');
    await db.rawDelete('''
  DELETE FROM ${Tables.remindersTable}
  ''');
  }

  Future<void> deleteDatabase() async{
    await databaseFactory.deleteDatabase(dbName);
  }
}