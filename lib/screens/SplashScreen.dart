//packages
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Services
import '../services/navigation_services.dart';
import '../services/media_services.dart';
import '../services/cloud_storage_services.dart';
import '../services/database_services.dart';
class SplashScreen extends StatefulWidget {
  final VoidCallback onIntialisationDone;

  const SplashScreen({required Key? key, required this.onIntialisationDone})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      _setup().then((_) => widget.onIntialisationDone());
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
        scaffoldBackgroundColor: const Color.fromRGBO(36, 35, 49, 1.0),
      ),
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 200),
                  SizedBox(
                    height: 100,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontFamily: 'Horizon',
                      ),
                      child: AnimatedTextKit(
                          isRepeatingAnimation: true,
                          animatedTexts: [
                            RotateAnimatedText("Secure Chat"),
                            RotateAnimatedText("Hi"),
                            RotateAnimatedText("Bonjour"),
                            RotateAnimatedText("Hola"),
                            RotateAnimatedText("Namaste"),
                            RotateAnimatedText("Secure Chat"),
                            RotateAnimatedText("Hi"),
                            RotateAnimatedText("Bonjour"),
                            RotateAnimatedText("Hola"),
                            RotateAnimatedText("Namaste"),
                            RotateAnimatedText("Secure Chat"),
                            RotateAnimatedText("Hi"),
                            RotateAnimatedText("Bonjour"),
                            RotateAnimatedText("Hola"),
                            RotateAnimatedText("Namaste"),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationServices>(NavigationServices());
    GetIt.instance.registerSingleton<MediaServices>(MediaServices());
    GetIt.instance.registerSingleton<CloudStorageServices>(CloudStorageServices());
    GetIt.instance.registerSingleton<DataBaseServices>(DataBaseServices());
  }
}
