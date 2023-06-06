import 'package:bloc/bloc.dart';
import 'package:network_call/cubit/CubitRocket.dart';

import '../model/ModelRocket.dart';
import '../repo/Repo.dart';

class CubitRocketDetails extends Cubit<CubitRocketState> {
  Repo? repo;
  String? id;
  CubitRocketDetails({this.repo, this.id}) : super(CubitRocketInitialState()) {
    getRocketDetails(id!);
  }
  getRocketDetails(String id) async {
    try {
      emit(CubitRocketLoadingState());
      final rockets = await repo!.getRocketDetails(id);

      emit(CubitRocketLoadedState(
          rocketDetails: ModelRocket.fromJson(rockets[1])));
    } catch (e) {
      emit(CubitRocketErrorState(error: e.toString()));
    }
  }
}
