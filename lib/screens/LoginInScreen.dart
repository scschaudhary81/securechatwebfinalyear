import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String route = "/log";
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      color: Colors.black54,
                      fontSize: 50.0,
                      fontFamily: 'Horizon',
                    ),
                    child: AnimatedTextKit(
                        isRepeatingAnimation: true,
                        animatedTexts: [
                          RotateAnimatedText("Dot Chat"),
                          RotateAnimatedText("Hi"),
                          RotateAnimatedText("Bonjour"),
                          RotateAnimatedText("Hola"),
                          RotateAnimatedText("Namaste"),
                        ]
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 200),
            MaterialButton(
              onPressed: (){},
              //shape:,
              child: const Text("Google Login",style: TextStyle(color: Colors.black54,fontSize: 20,fontFamily: 'Horizon',letterSpacing: 1.0),),
              elevation: 10,
            ),
          ],
        ),
      ),
    );
  }
}
