import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksTitleColumnName = "title";
  final String _tasksDescColumnName = "desc";
  final String _tasksDaysColumnName = "days";
  final String _tasksStatusColumnName = "status";

  DatabaseService._constructor();

  Future<Database> get database async{
    if(_db!=null) return _db!;
    _db = await getDatabase();
    return _db!; 
  }

  Future<Database> getDatabase() async{
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath,"tasks.db");
    
    final database = await openDatabase(
      databasePath, version: 1,
      onCreate: (db,version){
        db.execute('''
          CREATE TABLE $_tasksTableName(
            $_tasksIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $_tasksTitleColumnName TEXT NOT NULL,
            $_tasksDescColumnName TEXT,
            $_tasksDaysColumnName TEXT,
            $_tasksStatusColumnName INTEGER
          )
        ''');
      }
    );
    return database;
  }

  Future<void> addTask(String taskName, String? desc, String? days,) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksTitleColumnName: taskName,
      _tasksDescColumnName: desc,
      _tasksDaysColumnName: days,
      _tasksStatusColumnName: 0
    });
  }

  Future<void> deleteTask(int id) async{
    final db=await database;
    await db.delete(_tasksTableName,where: '$_tasksIdColumnName = ?', whereArgs: [id]);
  }

  Future<void> updateTask(int id, String title, String? desc, String? days, int status) async{
    final db = await database;
    await db.update(_tasksTableName, {
      _tasksTitleColumnName: title,
      _tasksDescColumnName: desc,
      _tasksDaysColumnName: days,
      _tasksStatusColumnName: status,
    }, where:'$_tasksIdColumnName = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return await db.query(_tasksTableName);
  }
}