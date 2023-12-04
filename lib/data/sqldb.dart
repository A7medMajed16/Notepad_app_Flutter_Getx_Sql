import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    _db ??= await initialDb();
    return _db;
  }

  Future<Database> initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'test.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {}

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE "notes" (
        "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "content" TEXT NOT NULL
      );
''');
    await db.execute('''
      CREATE TABLE "favorite_notes" (
        "id" INTEGER NOT NULL PRIMARY KEY
      );
''');
  }

  Future<dynamic> readData(String sql) async {
    Database? mydb = await db;
    List<Map> result = await mydb!.rawQuery(sql);
    return result;
  }

  Future<dynamic> insertData(String sql) async {
    Database? mydb = await db;
    int result = await mydb!.rawInsert(sql);
    return result;
  }

  Future<dynamic> updateData(String sql) async {
    Database? mydb = await db;
    int result = await mydb!.rawUpdate(sql);
    return result;
  }

  Future<dynamic> removeData(String sql) async {
    Database? mydb = await db;
    int result = await mydb!.rawDelete(sql);
    return result;
  }

  deleteAllDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'test.db');
    await deleteDatabase(path);
  }
}
