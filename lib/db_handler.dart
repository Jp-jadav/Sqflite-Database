import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'student_model.dart';

class DbHandler {
  static Database? database;

  Future<Database?> get db async {
    if (database != null) {
      return database;
    }
    database = await initDatabase();
    return database;
  }

  initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'NewData.db');

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE Test (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)",
        );
      },
    );

    return database;
  }

  Future<Student> insert(Student student) async {
    var dbClient = await db;
    await dbClient!.insert("Test", student.toMap());
    return student;
  }

  Future<List<Student>> getStudent() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> queryResult = await dbClient!.query("Test");
    return queryResult.map((e) => Student.fromMap(e)).toList();
  }

  Future<int> update(Student student) async {
    var dbClient = await db;
    return await dbClient!.update("Test", student.toMap(),
        where: 'id = ?', whereArgs: [student.id]);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('Test', where: 'id = ?', whereArgs: [id]);
  }
}
