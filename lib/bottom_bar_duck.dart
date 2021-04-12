library bottom_bar_duck;
import 'package:flutter/material.dart';
import 'bottom_bar_view.dart';
import 'tab_icon_data.dart';

class BottomBarDuck extends StatefulWidget {
  BottomBarDuck({
    Key key,
    @required this.subPages,
    this.duckColor,
    this.duckIcon,
    this.duckCallBack,
    @required this.tabIconsList,
    this.changeIndex}) : super(key: key);
  final List<Widget> subPages;
  final Color duckColor;
  final Widget duckIcon;
  final VoidCallback duckCallBack;
  final List<TabIconData> tabIconsList;
  final Function(int index) changeIndex;

  @override
  TabControllerState createState() => TabControllerState();
}


class TabControllerState extends State<BottomBarDuck> {
  Widget tabBody = Container(color: Color(0xFFF3F3F3),);
  @override
  void initState() {
    super.initState();
    assert(widget.subPages.length != 0);
    for (final TabIconData tab in widget.tabIconsList) {
      tab.isSelected = false;
    }
    widget.tabIconsList[0].isSelected = true;
    tabBody = widget.subPages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF3F3F3),
      child: Stack(
        children: [
          tabBody,
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              BottomBarView(
                changeIndex: (index) {
                  setState(() {
                    tabBody = widget.subPages[index];
                    if (widget.changeIndex != null) {
                      widget.changeIndex(index);
                    }
                  });
                },
                addClick: (){
                  if (widget.duckCallBack != null) {
                    widget.duckCallBack();
                  }

                },
                duckIcon: widget.duckIcon,
                duckColor: widget.duckColor,
                tabIconsList: widget.tabIconsList,
              )
            ],
          )

        ],
      ),
    );
  }


}


