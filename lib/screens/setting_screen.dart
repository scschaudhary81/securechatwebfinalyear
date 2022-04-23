//packages
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//providers
import '../providers/authentication_provider.dart';

//widgets
import '../widgets/top_bar_widget.dart';
import '../widgets/custom_rounded_image_widget.dart';

//constant
import '../constants.dart';

//data base services
import '../services/database_services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _height;
  late double _width;
  late AuthenticationProvider _auth;
  late DataBaseServices _db;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DataBaseServices>();
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
          TopBarWidget(
            "Settings",
          ),
          _userInfoWidget(),
          SizedBox(
            height: _height * .005,
          ),
          _secureButton(),
          SizedBox(
            height: _height * .01,
          ),
          _logOutButton(),
        ],
      ),
    );
  }

  Widget _userInfoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomRoundedImageFileWidgetForSettingPage(
            size: _height * .30, imageURl: _auth.user.imageURL),
        SizedBox(
          height: _height * 0.005,
        ),
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          shadowColor: appMainColor,
          elevation: .1,
          child: Container(
            height: _height * .20,
            width: _width * .70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      color: appMainColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _auth.user.name,
                      style: const TextStyle(color: textColor, fontSize: 25),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      color: appMainColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _auth.user.email,
                      style: const TextStyle(color: textColor, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _secureButton() {
    return Container(
      height: _height * .15,
      width: _width * .30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            _auth.isOffline?"Private":"Public",
            style: const TextStyle(
                color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          CupertinoSwitch(
            value: _auth.isOffline,
            activeColor: appMainColor,
            trackColor: Colors.redAccent,
            onChanged: (_value) {
              setState(() {
                if (!mounted) return;
                _auth.isOffline = !_auth.isOffline;
                if (_auth.isOffline) {
                  _db.updateUserLastSeenToHideTime(_auth.user.uid,
                      DateTime.now().subtract(const Duration(days: 10)));
                } else {
                  _db.updateUserLastSeenToHideTime(
                      _auth.user.uid, DateTime.now());
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _logOutButton() {
    return MaterialButton(
      height: _height*0.08,
      minWidth: _width*0.15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      color: appMainColor,
      onPressed: () async {
        await _auth.logout();
      },
      child: const Text(
        "Log out",
        style: TextStyle(color: Colors.white,fontSize: 17),
      ),
    );
  }
  double min(double a,double b){
    return a<b?a:b;
  }
}
