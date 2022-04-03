//screens
import '../screens/LoginInScreen.dart';
//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../services/navigation_services.dart';

class InBetweenScreen extends StatefulWidget {
  static const route = "/in_between_screen";
  const InBetweenScreen({Key? key}) : super(key: key);

  @override
  State<InBetweenScreen> createState() => _InBetweenScreenState();
}

class _InBetweenScreenState extends State<InBetweenScreen> {
  late NavigationServices _navigationServices;
  @override
  Widget build(BuildContext context) {
    _navigationServices = GetIt.instance.get<NavigationServices>();
    Future.delayed(const Duration(seconds: 1)).then((value) => _navigationServices.popAndNavigateToRoute(LoginScreen.route));
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child:const  CircularProgressIndicator(color: Colors.teal,),
      ),
    );
  }
}
