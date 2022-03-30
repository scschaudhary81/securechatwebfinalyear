//Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';


//services
import '../services/database_services.dart';
import '../services/navigation_services.dart';

class AuthenticationProvider extends ChangeNotifier{
  late final FirebaseAuth _auth;
  late final NavigationServices _navigationServices;
  late final DataBaseServices _dataBaseServices;
  AuthenticationProvider()
  {
    _auth = FirebaseAuth.instance;
    _dataBaseServices = GetIt.instance.get<DataBaseServices>();
    _navigationServices = GetIt.instance.get<NavigationServices>();
  }

}