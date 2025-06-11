import 'package:flashcard_app/model/flashcard_model.dart';
import 'package:flashcard_app/model/topic_model.dart'; // Import the new Topic model
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
        // Creating topics table
        await db.execute('''
          CREATE TABLE topics(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
        // Creating flashcards table with a foreign key to topics
        await db.execute('''
        CREATE TABLE flashcards (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question TEXT,
            answer TEXT,
            repeatCard INTEGER DEFAULT 0,
            remembered INTEGER DEFAULT 0,
            topic_id INTEGER,
            FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
        )
        ''');
      },
    );
  }

  // User related functions (unchanged)
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
    }
  }

  // --- Topic Management Functions ---

  // Insert a new topic
  static Future<int> insertTopic(Topic topic) async {
    final db = await DbHelper.db();
    return await db.insert(
      'topics',
      topic.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all topics
  static Future<List<Topic>> getAllTopics() async {
    final db = await DbHelper.db();
    final List<Map<String, dynamic>> maps = await db.query('topics');
    return List.generate(maps.length, (i) {
      return Topic.fromMap(maps[i]);
    });
  }

  // Delete a topic and all its associated flashcards (due to ON DELETE CASCADE)
  static Future<void> deleteTopic(int id) async {
    final db = await DbHelper.db();
    await db.delete('topics', where: 'id = ?', whereArgs: [id]);
  }

  // --- Flashcard Management Functions (modified to include topic_id) ---

  // Insert a new flashcard for a specific topic
  static Future<int> insertFlashCard(FlashCard card) async {
    final db = await DbHelper.db();
    return await db.insert('flashcards', card.toMap());
  }

  // Get all flashcards for a specific topic
  static Future<List<FlashCard>> getFlashCardsByTopic(int topicId) async {
    final db = await DbHelper.db();
    final result = await db.query(
      'flashcards',
      where: 'topic_id = ?',
      whereArgs: [topicId],
      orderBy: 'id ASC', // Order by ID for consistent retrieval
    );
    return result.map((e) => FlashCard.fromMap(e)).toList();
  }

  // Get all flashcards (original function, might be less used now)
  static Future<List<FlashCard>> getAllFlashCards() async {
    final db = await DbHelper.db();
    final result = await db.query('flashcards');
    return result.map((e) => FlashCard.fromMap(e)).toList();
  }

  // Delete a flashcard
  static Future<void> deleteFlashCard(int id) async {
    final db = await DbHelper.db();
    await db.delete('flashcards', where: 'id = ?', whereArgs: [id]);
  }

  // Update a flashcard
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
