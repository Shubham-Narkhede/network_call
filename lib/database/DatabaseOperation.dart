import '../main.dart';
import '../model/ModelRocket.dart';
import 'DatabaseHelper.dart';

/// DataBaseOperation is a singlton class created for all the operation like get, add from the local database
class DataBaseOperation {
  DataBaseOperation._();

  // here we have created instance of class
  static final instance = DataBaseOperation._();

  /// InsertData this method is created for insert all the information in sqflite database
  insertData(ModelRocket x) async {
    final allRows = await dbHelper.queryAllRows();

    bool contains =
        allRows.where((element) => element['id'] == x.id).toList().isEmpty;

    if (contains) {
      dbHelper.insert({
        DatabaseHelper.columnName: x.name,
        DatabaseHelper.columnEngineNumber: x.engines!.number.toString(),
        DatabaseHelper.columnRocketId: x.id,
        DatabaseHelper.columnImages: x.flickrImages.toString(),
        DatabaseHelper.columnCountry: x.country.toString(),
        DatabaseHelper.columnActive: x.active.toString(),
        DatabaseHelper.columnCostPerLaunch: x.costPerLaunch.toString(),
        DatabaseHelper.columnSuccessRatePct: x.successRatePct.toString(),
        DatabaseHelper.columnDescription: x.description.toString(),
        DatabaseHelper.columnWikipedia: x.wikipedia.toString(),
        DatabaseHelper.columnHeightMeter: x.height!.meters.toString(),
        DatabaseHelper.columnHeightFeet: x.height!.feet.toString(),
        DatabaseHelper.columnDiameterMeter: x.diameter!.meters.toString(),
        DatabaseHelper.columnDiameterFeet: x.height!.feet.toString()
      });
    }
  }

  /// to get all the stored data we have created this method
  Future<List<ModelRocket>> getAllStoredData() async {
    List<ModelRocket> list = [];
    final allRows = await dbHelper.queryAllRows();
    List<String> listImages = [];

    allRows.forEach((element) {
      final removedBrackets = element[DatabaseHelper.columnImages]
          .substring(1, element[DatabaseHelper.columnImages].length - 1);
      final parts = removedBrackets.split(', ');

      list.add(ModelRocket(
          id: element[DatabaseHelper.columnRocketId],
          name: element[DatabaseHelper.columnName],
          country: element[DatabaseHelper.columnCountry],
          engines: Engines(
            number: int.parse(element[DatabaseHelper.columnEngineNumber]),
          ),
          flickrImages: parts));

      listImages.clear();
    });

    return list;
  }

  // This method is created for getting detail of rocket from id
  Future<ModelRocket> getRocketDetails(String id) async {
    ModelRocket rocket;
    final allRows = await dbHelper.queryRocketDetail(id);
    dynamic data = allRows[0];

    final removedBrackets = data[DatabaseHelper.columnImages]
        .substring(1, data[DatabaseHelper.columnImages].length - 1);
    final parts = removedBrackets.split(', ');

    rocket = ModelRocket(
        id: data[DatabaseHelper.columnRocketId],
        name: data[DatabaseHelper.columnName],
        engines: Engines(
          number: int.parse(data[DatabaseHelper.columnEngineNumber]),
        ),
        flickrImages: parts,
        country: data[DatabaseHelper.columnCountry],
        active: data[DatabaseHelper.columnActive] == "true" ? true : false,
        successRatePct: int.parse(data[DatabaseHelper.columnSuccessRatePct]),
        description: data[DatabaseHelper.columnDescription],
        wikipedia: data[DatabaseHelper.columnWikipedia],
        height: Diameter(
            meters: double.parse(data[DatabaseHelper.columnHeightMeter]),
            feet: double.parse(data[DatabaseHelper.columnHeightFeet])),
        diameter: Diameter(
            meters: double.parse(data[DatabaseHelper.columnDiameterMeter]),
            feet: double.parse(data[DatabaseHelper.columnDiameterFeet])),
        costPerLaunch:
            int.parse(data[DatabaseHelper.columnCostPerLaunch].toString()));

    return rocket;
  }
}
