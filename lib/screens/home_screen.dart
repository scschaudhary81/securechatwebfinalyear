//Packages
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const route = "/home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return _actualUi();
  }

  Widget _actualUi() {
    return Scaffold(

    );
  }
}
