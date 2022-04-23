//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

//services
import '../services/navigation_services.dart';

//widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_rounded_button.dart';

//providers
import '../providers/authentication_provider.dart';

//screens
import '../screens/registration_screen.dart';

//constants
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String route = "/log";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late double _height;
  late double _width;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  late AuthenticationProvider _authenticationProvider;
  late NavigationServices _navigationServices;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _authenticationProvider = Provider.of<AuthenticationProvider>(context);
    _navigationServices = GetIt.instance.get<NavigationServices>();
    return _actualUi();
  }

  Widget _actualUi() {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: _width * .03, horizontal: _height * .03),
              height: _height * .98,
              width: _width * .46,
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
          ),
          if(isLoading)Center(
            child: const CircularProgressIndicator(color: appMainColor,),
          ),
        ],
      ),
    );
  }

  Widget _textTitle() {
    return const Text(
      "Secure Chat",
      style: TextStyle(
          fontSize: 50, color: appMainColor, fontWeight: FontWeight.w600),
    );
  }

  Widget _formLogin() {
    return Container(
      height: _height * 0.28,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInputField(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                hintText: "Email",
                isObscured: false,
                regExp: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
            SizedBox(height: _height * .04),
            CustomInputField(
                onSaved: (_value) {
                  _password = _value;
                },
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
      onPressed: () {
        setState(() {
          isLoading = true;
        });
        FocusManager.instance.primaryFocus?.unfocus();
        if (_formKey.currentState!.validate()) {
          print("email : $_email password : $_password");
          _formKey.currentState!.save();
          print("email : $_email password : $_password");
          _authenticationProvider
              .loginUsingEmailAndPassword(_email!, _password!, context)
              .then(
            (value) {
              if (!value) {
                Fluttertoast.showToast(
                    msg: "Enter Correct Email and Password!!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: appMainColor,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          );
        }
        if(!mounted) return;
        setState(() {
          isLoading = false;
        });
      },
      width: _width * 0.65,
      height: _height * 0.065,
      name: "Login",
    );
  }

  Widget _registerNewUser() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        child: const Text(
          "Don't have and account",
          style: TextStyle(color: appMainColor),
        ),
      ),
      onTap: () {
        _navigationServices.popAndNavigateToRoute(RegisterScreen.route);
      },
    );
  }
}
