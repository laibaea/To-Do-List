import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "todo.db";
  static final _databaseVersion = 1;
  static final table = 'Tasks';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        priority TEXT NOT NULL
      )
    ''');
  }

  Future<int> saveTask(Map<String, dynamic> task) async {
    var dbClient = await db;
    int res = await dbClient.insert(table, task);
    return res;
  }

  Future<int> updateTask(Map<String, dynamic> task) async {
    var dbClient = await db;
    int res = await dbClient
        .update(table, task, where: "id = ?", whereArgs: [task['id']]);
    return res;
  }

  Future<List<Map<String, dynamic>>> getTasks([String? priority]) async {
    var dbClient = await db;
    if (priority != null && priority.isNotEmpty) {
      return await dbClient
          .query(table, where: "priority = ?", whereArgs: [priority]);
    }
    return await dbClient.query(table);
  }

  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
