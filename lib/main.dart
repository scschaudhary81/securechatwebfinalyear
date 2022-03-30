//screens
import './screens/LoginInScreen.dart';
import './screens/SplashScreen.dart';

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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (ctx) => AuthenticationProvider()),
      ],
      child: MaterialApp(
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
        navigatorKey: NavigationServices.navigationKey,
        initialRoute: LoginScreen.route,
        routes: {
          LoginScreen.route: (BuildContext context) => LoginScreen(),
        },
      ),
    );
  }
}
