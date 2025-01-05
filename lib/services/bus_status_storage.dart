import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'bus_status_model.dart';

class BusStatusStorage {
  static Database? _database;
  static final String tableName = 'bus_status';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bus_status.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            busId TEXT NOT NULL,
            routeId TEXT NOT NULL,
            reason TEXT NOT NULL,
            details TEXT,
            timestamp TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<int> insertStatus(BusStatus status) async {
    final db = await database;
    return await db.insert(
      tableName,
      status.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<BusStatus>> getAllStatuses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return BusStatus.fromJson(maps[i]);
    });
  }

  static Future<int> deleteStatus(String busId, DateTime timestamp) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'busId = ? AND timestamp = ?',
      whereArgs: [busId, timestamp.toIso8601String()],
    );
  }

  static Future<int> deleteAllStatusesForBus(String busId) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'busId = ?',
      whereArgs: [busId],
    );
  }
}