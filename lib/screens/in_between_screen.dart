//screens
import 'package:provider/provider.dart';
//packages
import 'package:flutter/material.dart';

//provider
import '../providers/authentication_provider.dart';

class InBetweenScreen extends StatefulWidget {
  static const route = "/in_between_screen";
  InBetweenScreen({Key? key}) : super(key: key);

  @override
  State<InBetweenScreen> createState() => _InBetweenScreenState();
}

class _InBetweenScreenState extends State<InBetweenScreen> {
  late AuthenticationProvider _auth ;
  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child:const  CircularProgressIndicator(color: Colors.teal,),
      ),
    );
  }
}
