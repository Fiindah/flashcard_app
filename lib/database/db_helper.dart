import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flashcard_app/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> db() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      version: 1,
      join(dbPath, 'flashcard_db'),
      onCreate: (db, version) async {
        // creating database users
        await db.execute('''
          CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT, 
          username TEXT, 
          email TEXT, 
          phone TEXT, 
          password TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE flashcards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question TEXT,
            answer TEXT
        )
        ''');
      },
    );
  }

  // fungsi create user atau menambah data baru
  static Future<void> registerUser({UserModel? data}) async {
    final db = await DbHelper.db();

    await db.insert('users', {
      'name': data?.name,
      'username': data?.username,
      'email': data?.email,
      'phone': data?.phone,
      'password': data?.password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    print("User registered successfully");
  }

  // Fungsi untuk read atu membaca data
  static Future<UserModel?> login(String email, String password) async {
    final db = await DbHelper.db();
    final List<Map<String, dynamic>> data = await db.query(
      'users',
      where: 'email = ? And password = ?',
      whereArgs: [email, password],
    );
    if (data.isNotEmpty) {
      return UserModel.fromMap(data.first);
    } else {
      return null;
      // throw Exception("Invalid email or password");
    }
  }

  static Future<int> insertFlashCard(FlashCard card) async {
    final db = await DbHelper.db();
    return await db.insert('flashcards', card.toMap());
  }

  static Future<List<FlashCard>> getAllFlashCards() async {
    final db = await DbHelper.db();
    final result = await db.query('flashcards');
    return result.map((e) => FlashCard.fromMap(e)).toList();
  }

  static Future<void> deleteFlashCard(int id) async {
    final db = await DbHelper.db();
    await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateFlashCard(FlashCard card) async {
    final db = await DbHelper.db();

    await db.update(
      'flashcards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }
}
