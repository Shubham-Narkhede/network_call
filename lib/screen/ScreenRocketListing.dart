import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_call/cubit/CubitRocket.dart';

class ScreenRocketLising extends StatefulWidget {
  @override
  _ScreenRocketLisingState createState() => _ScreenRocketLisingState();
}

class _ScreenRocketLisingState extends State<ScreenRocketLising> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CubitRocketCubit, CubitRocketState>(
        builder: (context, state) {
          if (state is CubitRocketLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CubitRocketErrorState) {
            return Center(
              child: Icon(Icons.close),
            );
          } else if (state is CubitRocketLoadedState) {
            final movies = state.listRockets;

            return ListView.builder(
              itemCount: movies!.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(
                    movies[index].name!,
                    style: TextStyle(color: Colors.white),
                  ),
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(movies[index].),
                  // ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
