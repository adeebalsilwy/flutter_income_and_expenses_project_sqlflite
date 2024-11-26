import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/category_model.dart';
import '../model/transaction_model.dart';
import '../model/report_model.dart';

class DatabaseHelper {
  static final _databaseName = "app_database.db";
  static final _databaseVersion = 1;

  // Table names
  static final tableCategory = 'category';
  static final tableTransaction = 'transactions';
  static final tableReport = 'report';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE $tableCategory (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableTransaction (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          categoryId INTEGER NOT NULL,
          amount REAL NOT NULL,
          date TEXT NOT NULL,
          type TEXT NOT NULL,
          FOREIGN KEY (categoryId) REFERENCES $tableCategory (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE $tableReport (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          month TEXT NOT NULL,
          totalIncome REAL NOT NULL,
          totalExpense REAL NOT NULL
        )
      ''');
    } catch (e) {
      print("Error creating tables: $e");
      rethrow;
    }
  }

  // Insert Operations
  Future<int> insertCategory(Category category) async {
    try {
      Database? db = await database;
      return await db!.insert(tableCategory, category.toMap());
    } catch (e) {
      print("Error inserting category: $e");
      rethrow;
    }
  }

  Future<int> insertTransaction(Transaction_model transaction) async {
    try {
      Database? db = await database;
      return await db!.insert(tableTransaction, transaction.toMap());
    } catch (e) {
      print("Error inserting transaction: $e");
      rethrow;
    }
  }

  Future<int> insertReport(Report report) async {
    try {
      Database? db = await database;
      return await db!.insert(tableReport, report.toMap());
    } catch (e) {
      print("Error inserting report: $e");
      rethrow;
    }
  }

  // Query Operations
  Future<List<Category>> getAllCategories() async {
    try {
      Database? db = await database;
      final List<Map<String, dynamic>> maps = await db!.query(tableCategory);
      return maps.map((map) => Category.fromMap(map)).toList();
    } catch (e) {
      print("Error fetching categories: $e");
      rethrow;
    }
  }

  Future<List<Transaction_model>> getAllTransactions() async {
    try {
      Database? db = await database;
      final List<Map<String, dynamic>> maps = await db!.query(tableTransaction);
      return maps.map((map) => Transaction_model.fromMap(map)).toList();
    } catch (e) {
      print("Error fetching transactions: $e");
      rethrow;
    }
  }

  Future<List<Report>> getAllReports() async {
    try {
      Database? db = await database;
      final List<Map<String, dynamic>> maps = await db!.query(tableReport);
      return maps.map((map) => Report.fromMap(map)).toList();
    } catch (e) {
      print("Error fetching reports: $e");
      rethrow;
    }
  }
// Add this method to your DatabaseHelper class
Future<List<Transaction_model>> getTransactions({DateTime? date, int? categoryId}) async {
  try {
    Database? db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (date != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'date = ?';
      whereArgs.add(date.toIso8601String().split('T')[0]); // Assuming date is stored as 'YYYY-MM-DD'
    }

    if (categoryId != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'categoryId = ?';
      whereArgs.add(categoryId);
    }

    final List<Map<String, dynamic>> maps = await db!.query(
      tableTransaction,
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
    return maps.map((map) => Transaction_model.fromMap(map)).toList();
  } catch (e) {
    print("Error fetching transactions: $e");
    rethrow;
  }
}

  // Update Operations
  Future<int> updateCategory(Category category) async {
    try {
      Database? db = await database;
      return await db!.update(
        tableCategory,
        category.toMap(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    } catch (e) {
      print("Error updating category: $e");
      rethrow;
    }
  }

  Future<int> updateTransaction(Transaction_model transaction) async {
    try {
      Database? db = await database;
      return await db!.update(
        tableTransaction,
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    } catch (e) {
      print("Error updating transaction: $e");
      rethrow;
    }
  }

  Future<int> updateReport(Report report) async {
    try {
      Database? db = await database;
      return await db!.update(
        tableReport,
        report.toMap(),
        where: 'id = ?',
        whereArgs: [report.id],
      );
    } catch (e) {
      print("Error updating report: $e");
      rethrow;
    }
  }

  // Delete Operations
  Future<int> deleteCategory(int id) async {
    try {
      Database? db = await database;
      return await db!.delete(tableCategory, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting category: $e");
      rethrow;
    }
  }

  Future<int> deleteTransaction(int id) async {
    try {
      Database? db = await database;
      return await db!
          .delete(tableTransaction, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting transaction: $e");
      rethrow;
    }
  }

  Future<int> deleteReport(int id) async {
    try {
      Database? db = await database;
      return await db!.delete(tableReport, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting report: $e");
      rethrow;
    }
  }
}
