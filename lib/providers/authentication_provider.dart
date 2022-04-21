//Packages
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
  bool isOffline  = false;

  AuthenticationProvider() {
    _auth = FirebaseAuth.instance;
    //if want to sign out Current User
    //  _auth.signOut();
    _dataBaseServices = GetIt.instance.get<DataBaseServices>();
    _navigationServices = GetIt.instance.get<NavigationServices>();
    _auth.authStateChanges().listen((_user) async{
      if (_user != null) {
        _dataBaseServices.updateUserLastSeenTime(_user.uid);
        _dataBaseServices.getUser(_user.uid).then((snapshot) async{
          if(snapshot!=null&&snapshot.exists)
            {
              Map<String, dynamic> _userData =
              snapshot!.data() as Map<String, dynamic>;
              user = ChatUser.fromJSON({
                "uid": _user.uid,
                "name": _userData["name"],
                "email": _userData["email"],
                "last_active": _userData["last_active"],
                "image": _userData["image"],

              });
              print("user logged in");
              _navigationServices.popAndNavigateToRoute(HomeScreen.route);
            }
          else {
            await _auth.signOut();
          }
        });
      } else {
        _navigationServices.popAndNavigateToRoute(LoginScreen.route);
      }
    });
  }

  Future<bool> loginUsingEmailAndPassword(
      String _email, String _password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      print("logged in ");
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<String?> registerUserWithEmailAndPassword(
      String _email, String _password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);
      return userCredential.user!.uid;
    } on FirebaseException {
      print("Error Logging in User");
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
