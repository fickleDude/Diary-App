import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//SIGLETON
//init db and create tables
class DatabaseHelper {

  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();

  //use _ for private variables
  static Database? _database;

  //implement lazy init with getter
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  static Future<Database> initDB() async {
    String noteTable = "CREATE TABLE Note("
        "id INTEGER PRIMARY KEY,"
        "userId TEXT,"
        "title TEXT,"
        "body TEXT,"
        "isPinned INTEGER);";

    String userTable = "CREATE TABLE User("
        "id INTEGER PRIMARY KEY,"
        "userId TEXT,"
        "title TEXT,"
        "body TEXT,"
        "isPinned INTEGER);";

    //GET DATABASE PATH
    String defaultPath = await getDatabasesPath();//get the default database location
    String databasePath = join(defaultPath, 'diary.db');//join the given path into a single path (database_path/database.db)


    //OPEN THE DATABASE
    return await openDatabase(
        databasePath,
        version: 1,
        onOpen: (db){},
        onCreate: (Database db, int version) async {
          await db.execute(noteTable);
          version = 1;
        }
    );
  }
}