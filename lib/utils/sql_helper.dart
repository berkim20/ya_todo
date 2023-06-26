import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:mx/todoitem.dart';
import 'package:mx/date_time_ext.dart';
import 'package:intl/intl.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        description TEXT NOT NULL,
        priority TEXT NOT NULL,
        date TEXT,
        completed TEXT
      )
      """);
  }


  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String description, String priority, DateTime? date, bool completed) async {
    final db = await SQLHelper.db();

    final newdate = date.getFormattedTime(Intl.getCurrentLocale());
    var cmp = '';
    if (completed) {
      cmp = 'true';
    } else cmp = 'false';

    final data = {'description': description, 'priority': priority, 'date' : newdate, 'completed' : cmp};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  // static Future<List<Map<String, dynamic>>> getItems() async {
  //   final db = await SQLHelper.db();
  //   return db.query('items', orderBy: "id");
  // }
  static Future<List<Map<String, Object?>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String description, String priority, String date, String completed) async {
    final db = await SQLHelper.db();

    final data = {
      'id' : id,
      'description': description,
      'priority' : priority,
      'date' : date,
      'completed' : completed
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateCompleted(
      int id, String completed) async {
    final db = await SQLHelper.db();

    final data = {
      'id' : id,
      'completed' : completed
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}