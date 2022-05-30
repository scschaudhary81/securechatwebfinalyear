//screens
import './screens/home_screen.dart';
import './screens/LoginInScreen.dart';
import './screens/SplashScreen.dart';
import './screens/in_between_screen.dart';
import './screens/registration_screen.dart';
//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//services
import './services/navigation_services.dart';

//providers
import './providers/authentication_provider.dart';

void main() {
  runApp(
    SplashScreen(
        key: UniqueKey(),
        onIntialisationDone: () {
          runApp(MyApp());
        }),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (ctx) => AuthenticationProvider()),
      ],
      child:_actualApp(context),
    );
  }
  Widget _actualApp(BuildContext context)
  {
    return  MaterialApp(
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      title: "Secure Chat",
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white24,
        ),
      ),
      darkTheme: ThemeData(
        backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
        ),
      ),
      navigatorKey:  NavigationServices.navigationKey,
      initialRoute: InBetweenScreen.route,
      routes: {
        LoginScreen.route: (BuildContext context) => LoginScreen(),
        HomeScreen.route: (BuildContext context) => HomeScreen(),
        InBetweenScreen.route : (BuildContext context) => InBetweenScreen(),
        RegisterScreen.route : (BuildContext context)=> RegisterScreen(),
      },
    );
  }

}
