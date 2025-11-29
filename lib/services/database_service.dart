import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/post.dart';
import '../models/user.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'school_life.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 创建用户表
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        isStudent INTEGER DEFAULT 0,
        studentId TEXT,
        name TEXT,
        college TEXT,
        major TEXT,
        enrollmentYear TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // 创建帖子表
    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        tags TEXT,
        isAnonymous INTEGER DEFAULT 0,
        imagePaths TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
  }

  // 插入新用户
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  // 获取所有用户
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', orderBy: 'id ASC');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // 根据手机号获取用户
  Future<User?> getUserByPhone(String phone) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', where: 'phone = ?', whereArgs: [phone]);
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // 根据ID获取用户
  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // 获取下一个用户ID（按注册顺序）
  Future<int> getNextUserId() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT seq FROM sqlite_sequence WHERE name = "users"'
    );
    
    if (result.isNotEmpty) {
      return result.first['seq'] + 1;
    }
    
    // 如果表是空的，返回1作为第一个用户ID
    return 1;
  }

  // 插入新帖子
  Future<int> insertPost(Post post) async {
    final db = await database;
    return await db.insert('posts', post.toMap());
  }

  // 获取所有帖子
  Future<List<Post>> getAllPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // 根据ID获取帖子
  Future<Post?> getPostById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts', where: 'id = ?', whereArgs: [id]);
    
    if (maps.isNotEmpty) {
      return Post.fromMap(maps.first);
    }
    return null;
  }

  // 根据用户ID获取帖子
  Future<List<Post>> getPostsByUserId(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'posts', 
      where: 'userId = ?', 
      whereArgs: [userId],
      orderBy: 'createdAt DESC'
    );
    
    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  // 更新帖子
  Future<int> updatePost(Post post) async {
    final db = await database;
    return await db.update('posts', post.toMap(), where: 'id = ?', whereArgs: [post.id]);
  }

  // 删除帖子
  Future<int> deletePost(int id) async {
    final db = await database;
    return await db.delete('posts', where: 'id = ?', whereArgs: [id]);
  }
}