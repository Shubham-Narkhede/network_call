import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:network_call/repo/Repo.dart';

import '../model/ModelRocket.dart';

part 'CubitState.dart';

class CubitRocketCubit extends Cubit<CubitRocketState> {
  Repo? repo;
  CubitRocketCubit({this.repo}) : super(CubitRocketInitialState()) {
    getListRockets();
  }

  getListRockets() async {
    try {
      emit(CubitRocketLoadingState());
      final rockets = await repo!.getListRocket();

      emit(CubitRocketLoadedState(
          listRockets: List<ModelRocket>.from(
              rockets[1].map((x) => ModelRocket.fromJson(x)))));
    } catch (e) {
      emit(CubitRocketErrorState(error: e.toString()));
    }
  }
}
