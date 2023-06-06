import 'dart:async';

import 'package:flutter/material.dart';

class WidgetCorousal extends StatefulWidget {
  List widgetList;
  double? height;
  Function(int)? onImageTap;
  Color? backgroundColor;
  Color? activeDotColor;
  Color? inactiveDotColor;
  double? dotMargin;
  bool isSlideShow;
  int duration;
  double padding;
  WidgetCorousal(
      {this.height,
      this.onImageTap,
      this.backgroundColor,
      this.inactiveDotColor,
      this.activeDotColor,
      this.dotMargin,
      required this.widgetList,
      this.isSlideShow = false,
      this.duration = 3,
      this.padding = 4});
  @override
  _WidgetCorousalState createState() => _WidgetCorousalState();
}

class _WidgetCorousalState extends State<WidgetCorousal> {
  List<Widget> _pages = [];
  int page = 0;
  int pageIndex = 0;
  Timer? _timer;

  final _controller = PageController();

  @override
  void initState() {
    super.initState();

    _pages = widget.widgetList.map((widget) {
      return _buildImagePageItem(widget);
    }).toList();

    if (widget.isSlideShow == true)
      _timer =
          Timer.periodic(Duration(seconds: widget.duration), (Timer timer) {
        if (pageIndex != (widget.widgetList.length - 1)) {
          pageIndex++;
        } else {
          pageIndex = 0;
        }

        _controller.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeIn,
        );
      });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? Colors.white,
      height: widget.height ?? 300.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index % _pages.length];
              },
              onPageChanged: (int p) {
                setState(() {
                  page = p;
                  pageIndex = p;
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 25,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.widgetList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 10,
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              widget.dotMargin != null ? widget.dotMargin! : 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == pageIndex
                            ? widget.activeDotColor ?? Colors.grey[400]
                            : widget.inactiveDotColor ?? Colors.grey[200],
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImagePageItem(myWidget) {
    return InkWell(
      onTap: () {
        if (widget.onImageTap != null) {
          widget.onImageTap!(pageIndex);
        }
      },
      child: myWidget,
    );
  }
}
