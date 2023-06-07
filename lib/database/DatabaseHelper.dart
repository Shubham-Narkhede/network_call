import 'package:network_call/model/ModelRocket.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'my_table';

  static const columnId = '_id';
  // static const columnName = 'data';
  // static const columnAge = 'age';

  static const columnName = 'name';
  static const columnRocketId = 'id';
  static const columnEngineNumber = 'engineNumber';
  static const columnImages = 'images';
  static const columnCountry = 'country';
  static const columnActive = 'activeState';
  static const columnCostPerLaunch = 'costPerLaunch';
  static const columnSuccessRatePct = 'successRatePct';
  static const columnDescription = 'description';
  static const columnWikipedia = 'wikipedia';
  static const columnHeightMeter = 'heightMeter';
  static const columnHeightFeet = 'heightFeet';
  static const columnDiameterMeter = 'diameterMeter';
  static const columnDiameterFeet = 'diameterFeet';

  late Database _db;

  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnRocketId TEXT NOT NULL,
            $columnImages TEXT NOT NULL,
            $columnEngineNumber TEXT NOT NULL,
            $columnCountry TEXT NOT NULL,
            $columnActive TEXT NOT NULL,
            $columnCostPerLaunch TEXT NOT NULL,
            $columnSuccessRatePct TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnWikipedia TEXT NOT NULL,
            $columnHeightMeter TEXT NOT NULL,
            $columnHeightFeet TEXT NOT NULL,
            $columnDiameterMeter TEXT NOT NULL,
            $columnDiameterFeet TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> data) async {
    return await _db.insert(table, data);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    return await _db.query(table);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<dynamic> queryRocketDetail(String id) async {
    return await _db
        .query(table, where: '$columnRocketId = ?', whereArgs: [id]);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    int id = row[columnId];
    return await _db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
