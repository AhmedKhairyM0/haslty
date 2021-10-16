import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/expense_model.dart';

class ExpenseCache {
  // singleton design pattern
  static final ExpenseCache _instance = ExpenseCache._internal();

  ExpenseCache._internal();

  factory ExpenseCache() {
    return _instance;
  }

  // table name and database name
  final _dbName = 'expenses_db.db';
  String tableName = 'expenses';

  // initialize instance of Database
  Database? _database;
  Future<Database> init() async {
    return _database ??= await connnectToDatabase();
  }

  Future<Database> connnectToDatabase() async {
    return await openDatabase(
      _dbName,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            date TEXT
            )''',
        );
      },
      onOpen: (db) {
        
        
        
      },
      version: 1,
    );
  }

  Future<void> insert(Expense expenseModel) async {
    Database database = await init();
    await database.rawInsert(
      '''
        INSERT INTO $tableName (title, amount, date) VALUES (?,?,?) 
      ''',
      [
        expenseModel.title,
        expenseModel.amount,
        DateFormat("yyyy-MM-dd").format(expenseModel.date)
      ],
    );
    
  }

  Future<Expense> getById(String id) async {
    Database database = await init();

    var expenseQuery = await database.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return expenseQuery.map((item) => Expense.fromMap(item)).toList()[0];
  }

  Future<List<Expense>> getAll(String table) async {
    Database database = await init();

    var query = await database.query(table);
    
    return query.map((item) => Expense.fromMap(item)).toList();
  }

  Future<void> update(Expense expenseModel) async {
    Database database = await init();

    await database.update(
      tableName,
      expenseModel.toMap(),
      where: 'id = ?',
      whereArgs: [expenseModel.id],
    );
  }

  Future<void> deleteForEver(Expense expenseModel) async {
    Database database = await init();

    await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [expenseModel.id],
    );
  }

  Future<void> deleteAllForEver() async {
    Database database = await init();

    await database.delete(tableName);
  }

  Future<void> disposeDatabase() async {
    Database database = await init();
    if (database.isOpen) await database.close();
  }
}
