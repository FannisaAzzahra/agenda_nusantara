import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('agenda_nusantara.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Tabel tasks
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        category TEXT NOT NULL,
        isCompleted INTEGER DEFAULT 0,
        completedDate TEXT DEFAULT ''
      )
    ''');

    // Tabel user (untuk login dan password)
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Insert default user: username = "user", password = "user"
    await db.insert('user', {'username': 'user', 'password': 'user'});
  }

  // ========== USER ==========

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<bool> checkLogin(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  Future<bool> checkPassword(String password) async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'password = ?',
      whereArgs: [password],
    );
    return result.isNotEmpty;
  }

  Future<void> updatePassword(String newPassword) async {
    final db = await database;
    await db.update('user', {'password': newPassword});
  }

  // ========== TASKS ==========

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((map) => Task.fromMap(map)).toList();
  }

  Future<int> countCompleted() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE isCompleted = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countIncomplete() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM tasks WHERE isCompleted = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> toggleTaskComplete(int id, bool isCompleted) async {
    final db = await database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    await db.update(
      'tasks',
      {
        'isCompleted': isCompleted ? 1 : 0,
        'completedDate': isCompleted ? today : '',
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Grafik: jumlah tugas selesai per hari (7 hari terakhir)
  Future<Map<String, int>> getCompletedPerDay() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT completedDate, COUNT(*) as count
      FROM tasks
      WHERE isCompleted = 1 AND completedDate != ''
      GROUP BY completedDate
      ORDER BY completedDate ASC
    ''');

    Map<String, int> data = {};
    for (var row in result) {
      data[row['completedDate'] as String] = row['count'] as int;
    }
    return data;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
