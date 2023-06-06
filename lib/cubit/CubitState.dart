part of 'CubitRocket.dart';

@immutable
abstract class CubitRocketState extends Equatable {}

class CubitRocketInitialState extends CubitRocketState {
  @override
  List<Object?> get props => [];
}

class CubitRocketLoadingState extends CubitRocketState {
  @override
  List<Object> get props => [];
}

class CubitRocketLoadedState extends CubitRocketState {
  CubitRocketLoadedState({this.listRockets, this.rocketDetails});

  final List<ModelRocket>? listRockets;
  final ModelRocket? rocketDetails;

  @override
  List<Object?> get props => [listRockets, rocketDetails];
}

class CubitRocketErrorState extends CubitRocketState {
  final String? error;
  CubitRocketErrorState({required this.error});
  @override
  List<Object?> get props => [error];
}
