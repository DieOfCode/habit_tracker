import 'dart:io';

import 'package:final_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = documentDirectory.path + 'habit.db';
    return await openDatabase(path, version: 1, onCreate: createTable,
        onConfigure: (Database database) async {
      await database.execute('PRAGMA foreign_keys = ON');
    });
  }

  void createTable(Database database, int version) async {
    await database.execute(
        'CREATE TABLE ${Habit.table} (id INTEGER PRIMARY KEY NOT NULL, uid TEXT, title TEXT NOT NULL, description TEXT, type TEXT NOT NULL, frequency INTEGER NOT NULL,period INTEGER NOT NULL,priority INTEGER NOT NULL,date INTEGER NOT NULL)');
    await database.execute(
        'CREATE TABLE completedDates (id INTEGER PRIMARY KEY NOT NULL, habit_id INTEGER NOT NULL,date INTEGER NOT NULL, FOREIGN KEY(habit_id) REFERENCES habits(id))');
  }
}
