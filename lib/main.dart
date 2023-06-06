import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_call/cubit/CubitRocket.dart';
import 'package:network_call/repo/Repo.dart';
import 'package:network_call/screen/ScreenRocketListing.dart';

import 'cubit/CubitRocketDetails.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MultiBlocProvider(providers: [
      BlocProvider(create: (_) => CubitRocket(repo: Repo.instance)),
    ], child: ScreenRocketListing()));
  }
}
