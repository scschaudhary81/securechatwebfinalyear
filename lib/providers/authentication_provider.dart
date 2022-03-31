//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

//services
import '../services/database_services.dart';
import '../services/navigation_services.dart';

//Modals
import 'package:final_year_project/modals/chat_user.dart';

//screens
import '../screens/home_screen.dart';
import '../screens/LoginInScreen.dart';

class AuthenticationProvider extends ChangeNotifier {
  late final FirebaseAuth _auth;
  late final NavigationServices _navigationServices;
  late final DataBaseServices _dataBaseServices;
  late ChatUser user;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    _dataBaseServices = GetIt.instance.get<DataBaseServices>();
    _navigationServices = GetIt.instance.get<NavigationServices>();
    _auth.authStateChanges().listen((_user) {
      if (_user != null) {
        _dataBaseServices.updateUserLastSeenTime(_user.uid);
        _dataBaseServices.getUser(_user.uid).then((snapshot) {
          Map<String, dynamic> _userData =
              snapshot!.data() as Map<String, dynamic>;
          user = ChatUser.fromJSON({
            "uid": _user.uid,
            "name": _userData["name"],
            "email": _userData["email"],
            "last_active": _userData["last_active"],
            "image": _userData["image"],
          });
          print(
              "Data for the logged in user -----------------------\n${user.toMap()} \n------------------");
        });
        _navigationServices.popAndNavigateToRoute(HomeScreen.route);
      } else {
        _navigationServices.popAndNavigateToRoute(LoginScreen.route);
      }
    });
  }

  Future<void> loginUsingEmailAndPassword(
      String _email, String _password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print("logged in ");
    } on FirebaseAuthException {
      print("Error logging user into Firebase");
    } catch (e) {
      print(e);
    }
  }

  bool currentLoginStatus() {
    return _auth.currentUser!=null;
  }
}
