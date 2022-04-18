//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
//providers
import '../providers/authentication_provider.dart';
//widgets
import '../widgets/top_bar_widget.dart';
//constant
import '../constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _height;
  late double _width;
  late AuthenticationProvider _auth;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _actualUi();
  }

  Widget _actualUi() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: _height * 0.02, horizontal: _width * 0.03),
      height: _height * .98,
      width: _width * .97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBarWidget("Settings",primaryWidget: IconButton(icon: const Icon(Icons.login_outlined,color: topBarColor,),onPressed: ()async{
            await _auth.logout();
          },),),
        ],
      ),
    );
  }
}