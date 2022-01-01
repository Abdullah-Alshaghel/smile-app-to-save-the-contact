import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqlite/models/contact.dart';

class DatabaseHelper {
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDataBase();
    return _database;
  }

  _initDataBase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(dataDirectory.path, _databaseName);
    return await openDatabase(databasePath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE  ${Contact.tblContact}(
  ${Contact.colId} ,
  ${Contact.colName} TEXT ,
  ${Contact.colMobile} NUMBER 
  )  
  ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }

  Future<List<Contact>> fetchContact() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tblContact);
    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();
  }
}
