import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// db helper
class DatabaseHelper {
   // singleton instance
  static final DatabaseHelper instance = DatabaseHelper._instance();
  
  static Database? _db;
// private constructor
  DatabaseHelper._instance();
  // table and columns names
  String studentsTable = "student_table";
  String colId = "id";
  String colName = "name";
  String colAge = "age";
// create database
  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }
 // initialize database
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "student.db");
    // print("Database path: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "CREATE TABLE $studentsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colAge INTEGER)");
      //  print("Table Created");
      },
    );
  }


// retrieve all student records as a list of maps
  Future<List<Map<String, dynamic>>> getStudentsMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(studentsTable);
    return result;
  }
// insert a new student record
  Future<int> insertStudent(Map<String, dynamic> student) async {
    Database? db = await this.db;
    final int result = await db!.insert(studentsTable, student);
    return result;
  }
// update an existing student record
  Future<int> updateStudent(Map<String, dynamic> student) async {
    Database? db = await this.db;
    final int result = await db!.update(studentsTable, student,
        where: "$colId = ?", whereArgs: [student[colId]]);
    return result;
  }
 // delete student record
  Future<int> deleteStudent(int id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      studentsTable,
      where: "$colId = ?",
      whereArgs: [id],
    );
    return result;
  }
 // delete entire database
  // Future<void> deleteDatabase() async {
  //   final dbPath = await getDatabasesPath();
  //   final path = join(dbPath, "students.db");
  //   await databaseFactory.deleteDatabase(path);
  //   print("Database deleted");
  // }
}
