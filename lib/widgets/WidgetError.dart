import 'package:flutter/material.dart';
import 'package:network_call/widgets/WidgetText.dart';

class WidgetError extends StatefulWidget {
  Function? onTap;
  String? error;
  WidgetError({this.onTap, this.error});
  @override
  _WidgetErrorState createState() => _WidgetErrorState();
}

class _WidgetErrorState extends State<WidgetError> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info,
                color: Colors.yellow,
                size: 30,
              ),
              if (widget.error != null)
                Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 6),
                    child: widgetText(widget.error!, fontSize: 16)),
              widgetText("Retry", color: Colors.grey.shade600)
            ],
          ),
        ),
      ),
    );
  }
}
