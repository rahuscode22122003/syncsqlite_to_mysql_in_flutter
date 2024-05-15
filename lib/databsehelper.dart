import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseHelper {
  SqfliteDatabaseHelper._internal(); // Changed constructor to private
  static final SqfliteDatabaseHelper instance = SqfliteDatabaseHelper._internal(); // Singleton pattern
  factory SqfliteDatabaseHelper() => instance;

  static const contactinfoTable = 'contactinfoTable';
  static const _version = 2; // Increment the version to trigger upgrade

  static Database? _db; // Nullable to allow null initialization

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'syncdatabase.db');
    print(dbPath);

    var openDb = await openDatabase(
      dbPath,
      version: 2, // Increment version to ensure onUpgrade is called
      onCreate: (Database db, int version) async {
        await db.execute("""
        CREATE TABLE $contactinfoTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId INTEGER NOT NULL,
          name TEXT,
          email TEXT,
          gender TEXT,
          createdAt TEXT
        )
      """);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute("ALTER TABLE $contactinfoTable ADD COLUMN userId INTEGER NOT NULL DEFAULT 0");
        }
      },
    );
    print('db initialized');
    return openDb;
  }
}
