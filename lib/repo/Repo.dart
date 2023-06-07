import 'package:network_call/helper/ApiHelper.dart';
import 'package:network_call/helper/httpConfig.dart';

/// This repo class we have crated to add operation for network call
class Repo {
  Repo._();
  static final instance = Repo._();

  // get list rocket this method is created for getting all the data of list rocket
  Future<dynamic> getListRocket() async {
    return await HttpMethod(apiUrl: ApiHelper.instance.apiRocket).getData();
  }

  // getRocketDetails this method is created for getting particular rocket detail
  Future<dynamic> getRocketDetails(String id) async {
    return await HttpMethod(apiUrl: "${ApiHelper.instance.apiRocket}/$id")
        .getData();
  }
}
