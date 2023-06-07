import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_call/cubit/CubitRocket.dart';
import 'package:network_call/model/ModelRocket.dart';
import 'package:sqflite/sqflite.dart';

import '../database/DatabaseOperation.dart';
import '../widgets/WidgetCarosual.dart';
import '../widgets/WidgetError.dart';
import '../widgets/WidgetLoader.dart';
import '../widgets/WidgetText.dart';
import 'ScreenRocketDetails.dart';

// ScreenRocketListing this screen is created for showing all the listing of rocket
class ScreenRocketListing extends StatefulWidget {
  @override
  _ScreenRocketListingState createState() => _ScreenRocketListingState();
}

class _ScreenRocketListingState extends State<ScreenRocketListing> {
  List<ModelRocket>? list;

  @override
  void initState() {
    super.initState();
    getDataFromLocal();

    DataBaseOperation.instance.clearCache(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: widgetText("Rocket Listing", fontSize: 20),
      ),

      /// if local database is null then we are showing loader until data loads
      body: list == null
          ? WidgetLoader()

          /// if list is empty means if local database is empty then we are fetching data from
          /// network and build the list using bloc
          : list!.isEmpty
              ? BlocListener<CubitRocket, CubitRocketState>(
                  listener: (_, state) {
                    if (state is CubitRocketLoadedState) {
                      /// by using this listener we are managing the data which we are putting in the
                      /// sqflite
                      state.listRockets!.forEach((x) {
                        DataBaseOperation.instance.insertData(x);
                      });
                    }
                  },
                  child: BlocBuilder<CubitRocket, CubitRocketState>(
                    builder: (context, state) {
                      if (state is CubitRocketLoadingState) {
                        return WidgetLoader();
                      } else if (state is CubitRocketErrorState) {
                        return WidgetError(
                          error: state.error,
                          onTap: () {
                            context.read<CubitRocket>().getListRockets();
                          },
                        );
                      } else if (state is CubitRocketLoadedState) {
                        return widgetList(state.listRockets!);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                )
              : widgetList(list!),
    );
  }

  Widget widgetList(List<ModelRocket> list) {
    return list.isEmpty
        ? Center(
            child: widgetText("No Data Available"),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              ModelRocket rocket = list[index];
              return InkWell(
                onTap: () {
                  /// Here we are navigating to the details page
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ScreenRocketDetails(
                                id: rocket.id!,
                              )));
                },
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.grey.shade200, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(0, 2),
                        spreadRadius: 4,
                        blurRadius: 3)
                  ]),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AbsorbPointer(
                        absorbing: true,
                        child: WidgetCorousal(
                          isSlideShow: true,
                          duration: 5,
                          widgetList: rocket.flickrImages!.map<Widget>((e) {
                            return Image.network(
                              e,
                              fit: BoxFit.fill,
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                  top: 8,
                                ),
                                child: widgetText(rocket.name!.toUpperCase(),
                                    fontSize: 16)),
                            widgetTextRow(Icons.location_on, rocket.country!),
                            Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: widgetTextRow(Icons.engineering,
                                  "${rocket.engines!.number.toString()} Count"),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
  }

  Widget widgetTextRow(IconData iconData, String title) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 21,
            color: Colors.grey.shade700,
          ),
          Container(
              margin: const EdgeInsets.only(left: 2),
              child: widgetText(title, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  /// this method is created for getting all the rockets from local db which we stored in database
  getDataFromLocal() {
    DataBaseOperation.instance.getAllStoredData().then((value) {
      setState(() {
        if (value.isEmpty) {
          list = [];
        } else {
          list = value;
        }
      });
    });
  }
}
