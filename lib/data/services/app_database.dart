import 'package:mesrevenus/data/models/my_modele.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static AppDatabase instance = AppDatabase._init();

  Database? _db;
  AppDatabase._init();
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDatabase();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initDatabase() async {
    String db_path = await getDatabasesPath();
    String path = join(db_path, 'datas.db');
    Database mydata = await openDatabase(
      path,
      onCreate: _createTable,
      version: 1,
    );
    return mydata;
  }

  Future _createTable(Database db, int version) async {
    await db.execute('''CREATE TABLE mydata(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    activity TEXT NOT NULL,
    dette INTEGER,
    depense INTEGER,
    gain INTEGER
    )''');
  }

  Future<void> createData(MyModele data) async {
    final mydata = await instance.db;
    await mydata!.insert('mydata', data.toMap());
  }

  Future<List<MyModele>> readData() async {
    final mydata = await instance.db;
    List<Map<String, dynamic>> response = await mydata!.query('mydata');

    return List.generate(
      response.length,
      (index) => MyModele.fromMap(response[index]),
    );
  }

  Future<void> deleteData(int id) async {
    final mydata = await instance.db;
    await mydata!.delete('mydata', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateData(MyModele data) async {
    final mydata = await instance.db;
    await mydata!.update(
      'mydata',
      data.toMap(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
  }

  Future<int> getTotalGain() async {
    final mydata = await instance.db;
    var result = await mydata!.rawQuery(
      'SELECT SUM(gain) AS total FROM mydata',
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  Future<int> getTotalDette() async {
    final myadata = await instance.db;
    var result = await myadata!.rawQuery(
      'SELECT SUM(dette) AS total FROM mydata',
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }

  Future<int> getTotalDepense() async {
    final mydata = await instance.db;
    var result = await mydata!.rawQuery(
      'SELECT SUM(depense) AS total FROM mydata',
    );
    return (result.first['total'] as num?)?.toInt() ?? 0;
  }
}
