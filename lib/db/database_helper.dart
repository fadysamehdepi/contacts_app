import 'package:contacts_app/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String _dbName = 'contacts.db';
  final String _tableName = 'contacts';
  final String _clnId = 'id';
  final String _clnName = 'name';
  final String _clnSurname = 'surname';
  final String _clnPhone = 'phone';
  final String _clnisFavorite = 'isFavorite';

  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    final path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE $_tableName(
  $_clnId INTEGER PRIMARY KEY AUTOINCREMENT,
  $_clnName TEXT NOT NULL , 
  $_clnSurname TEXT NOT NULL,
  $_clnPhone TEXT NOT NULL,
  $_clnisFavorite INTEGER DEFAULT 0
  )''');
      },
    );
  }

  // Insert Contact
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert(_tableName, contact.toMap());
  }

  // Get all Contacts
  Future<List<Contact>> getAllcontacts() async {
    final db = await database;
    final result = await db.query(
      _tableName,
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return result.map((contactMap) => Contact.fromMap(contactMap)).toList();
  }

  //Search in contacts
  Future<List<Contact>> searchcontacts(String query) async {
    final db = await database;
    final result = await db.query(
      _tableName,
      where: '$_clnName LIKE ? OR $_clnPhone LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name COLLATE NOCASE ASC',
    );
    return result.map((contactMap) => Contact.fromMap(contactMap)).toList();
  }

  // Update contact
  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      _tableName,
      contact.toMap(),
      where: '$_clnId = ?',
      whereArgs: [contact.id],
    );
  }

  //delete contact
  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: '$_clnId = ?', whereArgs: [id]);
  }

  Future<int> toggleFavorite(int id, int isFavorite) async {
    final db = await database;
    return await db.update(
      _tableName,
      {'$_clnisFavorite': isFavorite},
      where: '$_clnId = ?',
      whereArgs: [id],
    );
  }
}
