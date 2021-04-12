import 'package:flutter/material.dart';
import 'tab_icon_data.dart';
import 'dart:math' as math;

class BottomBarView extends StatefulWidget {
  const BottomBarView({
    Key key,
    this.tabIconsList,
    this.changeIndex,
    this.addClick,
    this.duckIcon,
    this.duckColor}) : super(key: key);

  final Widget duckIcon;
  final Color duckColor;
  final List<TabIconData> tabIconsList;
  final Function(int index) changeIndex;
  final Function() addClick;

  @override
  BottomBarViewState createState() => BottomBarViewState();

}


class BottomBarViewState extends State<BottomBarView> with TickerProviderStateMixin {

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    if (mounted) {
      setState(() {
        for (final TabIconData tab in widget.tabIconsList) {
          tab.isSelected = false;
          if (tabIconData.index == tab.index) {
            tab.isSelected = true;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        AnimatedBuilder(animation: animationController,
            builder: (BuildContext context, _) {
              return
                PhysicalShape(
                  color: Color(0xFFFFFFFF),
                  elevation: 16,
                  clipper: TabClipper(
                      radius: Tween<double>(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(
                          parent: animationController,
                          curve: Curves.fastOutSlowIn))
                          .value *
                          40.0
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 62,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: TabIcons(
                                    tabIconData: widget.tabIconsList[0],
                                    removeAllSelect: () {
                                      setRemoveAllSelection(widget.tabIconsList[0]);
                                      widget.changeIndex(0);
                                    }),
                              ),
                              Expanded(
                                child: TabIcons(
                                    tabIconData: widget.tabIconsList[1],
                                    removeAllSelect: () {
                                      setRemoveAllSelection(
                                          widget.tabIconsList[1]);
                                      widget.changeIndex(1);
                                    }),
                              ),
                              SizedBox(
                                width: Tween<double>(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                    parent: animationController,
                                    curve: Curves.fastOutSlowIn))
                                    .value *
                                    64.0,
                              ),
                              Expanded(
                                child: TabIcons(
                                    tabIconData: widget.tabIconsList[2],
                                    removeAllSelect: () {
                                      setRemoveAllSelection(
                                          widget.tabIconsList[2]);
                                      widget.changeIndex(2);
                                    }),
                              ),
                              Expanded(
                                child: TabIcons(
                                    tabIconData: widget.tabIconsList[3],
                                    removeAllSelect: () {
                                      setRemoveAllSelection(
                                          widget.tabIconsList[3]);
                                      widget.changeIndex(3);
                                    }),
                              )

                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      )
                    ],
                  ),
                );
            }),
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            width: 38 * 2.0,
            height: 38 + 62.0,
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: SizedBox(
                width: 38 * 2.0,
                height: 38 * 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Curves.fastOutSlowIn)),
                    child: Container(
                      // alignment: Alignment.center,s
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: FloatingActionButton(
                        child: widget.duckIcon != null ? widget.duckIcon : Icon(Icons.add),
                        backgroundColor: widget.duckColor != null ? widget.duckColor: Colors.lightBlue[900],
                        onPressed: () => widget.addClick(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        )
      ],
    );

  }

}


class TabIcons extends StatefulWidget {
  const TabIcons(
      { this.tabIconData,  this.removeAllSelect, Key key})
      : super(key: key);

  final TabIconData tabIconData;
  final Function() removeAllSelect;

  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        widget.removeAllSelect();
        animationController.reverse();
      }
    });
    super.initState();
  }

  void setAnimation() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Center(
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                    CurvedAnimation(
                        parent: animationController,
                        curve: const Interval(0.1, 1.0,
                            curve: Curves.fastOutSlowIn))),
                child: Image.asset(widget.tabIconData.isSelected
                    ? widget.tabIconData.selectedImagePath
                    : widget.tabIconData.imagePath),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 40.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double v = radius * 2;
    path.lineTo(0, 0);
    //        270
    //  180       0
    //       90
    // radius /2 为半径，（radius /2，radius /2）为原点，从180度角开始，逆时针画90度的圆弧
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    //270度开始，逆时针画70度
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);
    // //
    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);
    // //
    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();//自动连接中间形状
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180) * degree;
    return redian;
  }

}
