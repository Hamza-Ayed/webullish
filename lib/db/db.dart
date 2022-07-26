import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBSql {
  static Database? _db;
  final String table;

  DBSql(this.table);

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();

      return _db;
    } else {
      return _db;
    }
  }

  initialDB() async {
    io.Directory docDirect = await getApplicationDocumentsDirectory();
    String path = join(docDirect.path, 'rest.db');
    var mydb = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
    return mydb;
  }

//UNIQUE
  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE tokens ('
        'id INTEGER PRIMARY KEY,'
        'token    TEXT    '
        ')');
    print('tokens Table Created');

    await db.execute('CREATE TABLE orders ('
        'id INTEGER PRIMARY KEY,'
        'title    TEXT    ,'
        'user_id      TEXT ,'
        'count      DOUBLE , '
        'content_id   TEXT'
        ')');
    print('order Table Created');
  }

  Future<int> insert(Map<String, dynamic> data) async {
    initialDB();
    var dbClient = await db;

    var insert = dbClient!.insert(table, data);

    return insert;
  }

  Future<List> getData(String table) async {
    var dbClinte = await db;
    var newsDistinct = await dbClinte!.rawQuery(
      // 'SELECT  title,imageurl,content,link,pubdate FROM $teamName ORDER BY pubdate DESC',
      'SELECT DISTINCT * FROM $table ',
    );
    return newsDistinct;
  }

  Future<List> getDataQuery(String table, qury) async {
    var dbClinte = await db;
    var newsDistinct = await dbClinte!.rawQuery(
      // 'SELECT  title,imageurl,content,link,pubdate FROM $teamName ORDER BY pubdate DESC',
      qury,
    );
    return newsDistinct;
  }

  Future<int> update(String table, id) async {
    var dbClient = await db;

    var updateUser = await dbClient!.rawDelete("""
UPDATE `Users` SET `has_copne`='2' WHERE `id`=$id
""");

    return updateUser;
  }

  Future<int> deleteAll(String table) async {
    var dbClient = await db;

    var deletednote = await dbClient!.rawDelete('DELETE FROM $table ');

    return deletednote;
  }

  Future<int> delete(String table, id) async {
    var dbClient = await db;

    var deletednote =
        await dbClient!.rawDelete('DELETE FROM $table Where id=$id');

    return deletednote;
  }

  Future<int> deleteUser(String table, deviceID) async {
    var dbClient = await db;

    var deletednote = await dbClient!
        .rawDelete('DELETE FROM $table Where devicename=$deviceID');

    return deletednote;
  }
}
