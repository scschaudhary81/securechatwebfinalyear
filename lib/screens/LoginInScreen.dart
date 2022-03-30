//packages
import 'package:flutter/material.dart';

//widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String route = "/log";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double _height;
  late double _width;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return _actualUi();
  }

  Widget _actualUi() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: _width * .03, horizontal: _height * .03),
        height: _height * .98,
        width: _width * .97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _textTitle(),
            SizedBox(
              height: _height * .05,
            ),
            _formLogin(),
            SizedBox(
              height: _height * .05,
            ),
            _loginButton(),
            SizedBox(
              height: _height * .03,
            ),
            _registerNewUser(),
          ],
        ),
      ),
    );
  }

  Widget _textTitle() {
    return const Text(
      "Secure Chat",
      style: TextStyle(
          fontSize: 50, color: Colors.teal, fontWeight: FontWeight.w600),
    );
  }

  Widget _formLogin() {
    return Container(
      height: _height * 0.20,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputField(
                onSaved: (_value) {},
                hintText: "Email",
                isObscured: false,
                regExp: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
            CustomInputField(
                onSaved: (_value) {},
                hintText: "Password",
                isObscured: true,
                regExp: r'.{8,}'),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return CustomRoundedButton(
      onPressed: () {},
      width: _width * 0.65,
      height: _height * 0.065,
      name: "Login",
    );
  }

  Widget _registerNewUser() {
    return GestureDetector(
      child: Container(
        child: const Text(
          'Don,t have and account',
          style: TextStyle(color: Colors.teal),
        ),
      ),
      onTap: () {
        //to implement
      },
    );
  }
}
