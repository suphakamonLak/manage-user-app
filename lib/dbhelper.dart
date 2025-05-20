import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pretest/user.dart';

class Dbhelper {
  Dbhelper._();
  static final Dbhelper instance = Dbhelper._();
  static Database? _database;

  Future<Database> get db async {
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    // await deleteDatabase(join(await getDatabasesPath(), 'usersdb.db')); // ลบฐานข้อมูลเก่า
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'usersdb.db');
    return await openDatabase(
      path, 
      version: 1, 
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade, // **เรียก onUpgrade เมื่ออัปเกรด database**
    );
  }

  Future _onCreate(Database db, int version) async {
  await db.execute("""CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        name TEXT, 
        age INTEGER NOT NULL, 
        hobby TEXT,
        internet TEXT
        );
    """);
  }

  Future<int> insertDog(User user) async {
    Database db = await instance.db;
    return await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.db;
    return await db.query('users');
  }

  Future<int> update(User user) async {
    Database db = await instance.db;
    if (user.id == null) return 0;  // ตรวจสอบว่ามี ID จริงหรือไม่
    return await db.update(
      "users",
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await instance.db;
    return await db.delete('users', where: "id = ?", whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    Database db = await instance.db;
    await db.delete('users');
  }
}
