import 'package:network_call/helper/ApiHelper.dart';
import 'package:network_call/helper/httpConfig.dart';

class Repo {
  Repo._();
  static final instance = Repo._();

  Future<dynamic> getListRocket() async {
    return await HttpMethod(apiUrl: ApiHelper.instance.apiRocket).getData();
  }

  Future<dynamic> getRocketDetails(String id) async {
    await HttpMethod(apiUrl: "${ApiHelper.instance.apiRocket}/$id").getData();
  }
}
