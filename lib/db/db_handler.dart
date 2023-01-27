import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pass_manager/model/sharedPrefs_handler.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pass_manager/model/data_model.dart';
import 'package:crypto/crypto.dart';

class Encryption{
  static Encrypted? _encrypted;
  static String? _decrypted;

  static encryptAES(String plainText){
    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    _encrypted = encrypter.encrypt(plainText, iv: iv);
    String res = _encrypted!.base64;
    return res;
    // print(_encrypted!.base64);
  }

  static decryptAES(String cipherText){
    final key = Key.fromLength(32);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    _decrypted = encrypter.decrypt64(cipherText, iv: iv);
    return _decrypted;
    // print(_decrypted);
  }
}
class DBHandler {
  DBHandler._();
  static final DBHandler dataBase = DBHandler._();    //SINGLETON
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDataBase();
    return _database!;
  }

  initDataBase() async {
    return await openDatabase(
      join(await getDatabasesPath(), "password_manager_db.db"),
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE userData (id INTEGER PRIMARY KEY AUTOINCREMENT, site TEXT, user TEXT, password TEXT)
       ''');
      },
      version: 1,
    );
  }

  addNewData(Data newData) async {
    final db = await database;
    db.insert("userData", newData.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  addNewDataFromMap(Map<String, dynamic> newData) async {
    final db = await database;
    db.insert("userData", newData,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<dynamic> getData() async {
    final db = await database;
    var res = await db.rawQuery("SELECT id, site, user FROM userData");
    if (res.isEmpty) {
      return Null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : Null;
    }
  }

  Future<String> queryPassword(int _id) async{
    final db = await database;
    var res = await db.rawQuery("SELECT password FROM userData WHERE id=?", ["$_id"]);
    String out = res.toString();
    return Encryption.decryptAES(res[0]["password"].toString());
  }

  Future<int> updateData(Map<String, dynamic> _row) async {
    final db = await database;
    var _id = _row['id'];
    print("Updating id: $_id");
    return await db.update("userData", _row, where: 'id = ?', whereArgs: [_id]);
  }

  Future<int> deleteData(int _id) async{
    final db = await database;
    return await db.delete("userData", where: 'id = ?', whereArgs: [_id]);
  }
}
