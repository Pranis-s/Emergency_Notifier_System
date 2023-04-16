import 'dart:html';
import 'package:final_try/model/contactsm.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String contactTable = 'contact_table';
  String colId = 'id';
  String colContactName = 'name';
  String colContactNumber = 'number';

  //named private constructor..(used to create an instance of a singleton class)
  //used to create only one instance of the DatabaseHelper class
  DatabaseHelper._createInstance();

  //creating an instance of the database
  static DatabaseHelper? _databaseHelper; //mathi ko class ko object
  //this database will be referenced using "this" keyword.
  //helps to access getters and setters of the class.
  // for eg: _database getter is used when we want to initialize the db

  factory DatabaseHelper() {
    //factory keyword allows constructor to return some value
    if (_databaseHelper == null) {
      //create an instace of _DatabaseHelper if no instance is created before
      _databaseHelper = DatabaseHelper._createInstance();
      //because of that null check, this line runs only once
    }
    return _databaseHelper!;
  }

  //Initialize the database
  static Database? _database;
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String directoryPath = await getDatabasesPath();
    String dbLocation = directoryPath + 'contact.db';

    var contactDatabase =
        await openDatabase(dbLocation, version: 1, onCreate: _createDbTable);
    return contactDatabase;
  }

  void _createDbTable(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $contactTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colContactName TEXT, $colContactNumber TEXT)');
  }

  //Fetch Operation: fet contact object from db
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT * FROM $contactTable order by $colId ASC');

    //or
    //var result = await db.query(contactTable, orderBy: '$colId ASC');
    return result;
  }

  //Insert a contact object
  Future<int> insertContact(TContact contact) async {
    Database db = await this.database;
    var result = await db.insert(contactTable, contact.toMap());
    // print (await db.query(contactTable));
    return result;
  }

  //update a contact object
  Future<int> updateContact(TContact contact) async {
    Database db = await this.database;
    var result = await db.update(contactTable, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
    return result;
  }

  //delete a contact object
  Future<int> deleteContact(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $contactTable WHERE $colId = $id');
    //print (await db.query(contactTable));
    return result;
  }

  //Get number of contact objects
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $contactTable');
    int result = Sqflite.firstIntValue(x)!;
    return result;
  }

  //Get the "Map List" [ List<Map> ] and convert it to "Contact list" [ List<Contact>]
  Future<List<TContact>> getContactList() async {
    var contactMapList =
        await getContactMapList(); // get 'Map List" from database
    int count =
        contactMapList.length; // Count number of map entries in db table

    List<TContact> contactList = <TContact>[];
    // For loop to create a "Contact List" from a "Map List"
    for (int i = 0; i < count; i++) {
      contactList.add(TContact.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }
}
// This is the dart file for local database to add trusted contacts 