//Packages
import 'package:flutter/material.dart';

//screens
import '../screens/chat_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/users_screen.dart';
//constants
import '../constants.dart';
class HomeScreen extends StatefulWidget {
  static const route = "/home_screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double _width;
  late double _height;
  int _idx = 0;
  final List<Widget> _screens = [
    ChatScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return _actualUi();
  }

  Widget _actualUi() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _screens[_idx],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: _width * .08,
        backgroundColor: Colors.white30,
        elevation: 0,
        unselectedItemColor: Colors.black26,
        selectedItemColor: appMainColor,
        currentIndex: _idx,
        onTap: (_selected) {
          setState(() {
            _idx = _selected;
          });
        },
        items: const [
          BottomNavigationBarItem(
              label: "Chats", icon: Icon(Icons.chat_bubble_outline_rounded,size: 40,),),
          BottomNavigationBarItem(
              label: "Users",
              icon: Icon(Icons.supervised_user_circle_outlined,size: 40,)),
          BottomNavigationBarItem(
              label: "Settings", icon: Icon(Icons.settings,size: 40,)),
        ],
      ),
    );
  }
}
