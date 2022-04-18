//packages
import 'package:flutter/material.dart';
//constant
import '../constants.dart';

class TopBarWidget extends StatelessWidget {
  final String _barTitle;
  Widget? primaryWidget;
  Widget? secondaryWidget;
  double? fontSize;

  late double _height;
  late double _width;

  TopBarWidget(this._barTitle,
      {this.secondaryWidget, this.primaryWidget, this.fontSize=40});

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return _actualUi();
  }

  Widget _actualUi() {
    return Container(
      padding: EdgeInsets.only(top: _height*.01,left: _width*.01),
      height: _height * 0.10,
      width: _width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (secondaryWidget != null) secondaryWidget!,
          _titleWidget(),
          if (primaryWidget != null) primaryWidget!,
        ],
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      _barTitle,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: topBarColor, fontSize: fontSize, fontWeight: FontWeight.w700),
    );
  }
}
