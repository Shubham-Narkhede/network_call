import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_call/cubit/CubitRocket.dart';
import 'package:network_call/cubit/CubitRocketDetails.dart';
import 'package:network_call/model/ModelRocket.dart';
import 'package:network_call/repo/Repo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/WidgetError.dart';
import '../widgets/WidgetLoader.dart';
import '../widgets/WidgetText.dart';

class ScreenRocketDetails extends StatefulWidget {
  final String id;

  ScreenRocketDetails({required this.id});
  @override
  _ScreenRocketDetailsState createState() => _ScreenRocketDetailsState();
}

class _ScreenRocketDetailsState extends State<ScreenRocketDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: widgetText("Rocket Details", fontSize: 20),
      ),
      body: BlocBuilder<CubitRocketDetails, CubitRocketState>(
        bloc: CubitRocketDetails(repo: Repo.instance, id: widget.id),
        builder: (context, state) {
          if (state is CubitRocketLoadingState) {
            return WidgetLoader();
          } else if (state is CubitRocketErrorState) {
            return WidgetError(
              error: state.error,
              onTap: () {
                context.read<CubitRocketDetails>().getRocketDetails(widget.id);
              },
            );
          } else if (state is CubitRocketLoadedState) {
            ModelRocket rocket = state.rocketDetails!;

            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Center(
                            child: widgetText(rocket.name!.toUpperCase(),
                                fontSize: 20))),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: rocket.flickrImages!.map<Widget>((e) {
                          return Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.network(
                                e,
                                height: MediaQuery.of(context).size.height / 4,
                              ));
                        }).toList(),
                      ),
                    ),
                    widgetRowText(
                        "Is Active: ", rocket.active == true ? "Yes" : "No"),
                    widgetRowText(
                        "Cost Per Launch: ", "₹ ${rocket.costPerLaunch}"),
                    widgetRowText(
                        "Success Rate percent: ", "${rocket.successRatePct}%"),
                    widgetRowText("Description: ", "${rocket.description}"),
                    widgetRowText("Wikipedia link: ", "${rocket.wikipedia}",
                        onTap: () async {
                      await launchUrl(Uri.parse(rocket.wikipedia!.toString()));
                    }),
                    widgetRowText("Height: ",
                        "${rocket.height!.feet} F /${rocket.height!.meters} m"),
                    widgetRowText("Diameter: ",
                        "${rocket.diameter!.feet} F /${rocket.diameter!.meters} m"),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget widgetRowText(String title, String value, {Function? onTap}) {
    return Container(
      margin: const EdgeInsets.only(
        top: 6,
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: title,
              style: const TextStyle(color: Colors.black, fontSize: 16)),
          TextSpan(
              text: value,
              style: TextStyle(
                  decoration: onTap == null ? null : TextDecoration.underline,
                  fontStyle: onTap == null ? null : FontStyle.italic,
                  color: onTap == null ? Colors.grey.shade700 : Colors.blue,
                  fontSize: 14))
        ])),
      ),
    );
  }
}
