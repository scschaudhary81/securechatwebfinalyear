//packages
import 'package:final_year_project/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//services
import '../services/media_services.dart';
import '../services/database_services.dart';
import '../services/cloud_storage_services.dart';

//widgets

import '../widgets/custom_rounded_button.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_rounded_image_widget.dart';

//providers
import '../providers/authentication_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = "/register_screen";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late double _height;
  late double _width;
  late MediaServices _mediaServices;
  late AuthenticationProvider _auth;
  late DataBaseServices _db;
  late CloudStorageServices _cloudStorageServices;
  late NavigationServices _navigationServices;
  final _formKey = GlobalKey<FormState>();
  bool _showSpinner = false;
  PlatformFile? _imageSelected;
  String? _name;
  String? _password;
  String? _email;

  @override
  Widget build(BuildContext context) {
    _mediaServices = GetIt.instance.get<MediaServices>();
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DataBaseServices>();
    _cloudStorageServices = GetIt.instance.get<CloudStorageServices>();
    _navigationServices = GetIt.instance.get<NavigationServices>();
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return _actualUi();
  }

  Widget _actualUi() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _showSpinner
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Loading",
                    style: TextStyle(
                        color: Colors.teal,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(color: Colors.teal),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: _width * .03, vertical: _height * .02),
              height: _height * .98,
              width: _width * .97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profilePicture(),
                  SizedBox(height: _height * .05),
                  _form(),
                  SizedBox(height: _height * .05),
                  _registerButton(),
                  SizedBox(height: _height * .10),
                ],
              ),
            ),
    );
  }

  Widget _form() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _width * .03),
      height: _height * .35,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomInputField(
                onSaved: (_value) {
                  setState(() {
                    _name = _value;
                  });
                },
                hintText: "Name",
                isObscured: false,
                regExp: r'.{2,}'),
            CustomInputField(
                onSaved: (_value) {
                  _email = _value;
                },
                hintText: "Email",
                isObscured: false,
                regExp: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
            CustomInputField(
                onSaved: (_value) {
                  _password = _value;
                },
                hintText: "Password",
                isObscured: true,
                regExp: r'.{8,}')
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return CustomRoundedButton(
      height: _height * .06,
      name: "Register",
      onPressed: () async {
        if (_formKey.currentState!.validate() && _imageSelected != null) {
          _formKey.currentState!.save();
          setState(() {
            _showSpinner = true;
          });
          String? _uid =
              await _auth.registerUserWithEmailAndPassword(_email!, _password!);
          if (_uid != null) {
            String? _imageUrl = await _cloudStorageServices
                .saveUserImageToStorage(_uid!, _imageSelected!);
            if (_imageUrl != null) {
              await _db.enterNewUserDataInDataBase(
                  _uid, _email!, _name!, _imageUrl!);
              Fluttertoast.showToast(
                  msg: "User Created Successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.teal,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              Fluttertoast.showToast(
                  msg: "Error Saving Profile Picture please try again later",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.teal,
                  textColor: Colors.white,
                  fontSize: 16.0);
              setState(() {
                _showSpinner = false;
              });
            }
          } else {
            Fluttertoast.showToast(
                msg: "Try Creating Account with another email",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.teal,
                textColor: Colors.white,
                fontSize: 16.0);
            setState(() {
              _showSpinner = false;
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: "Please Enter data in all the require fields correctly",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      width: _width * .6,
    );
  }

  Widget _profilePicture() {
    return GestureDetector(
      onTap: () {
        _mediaServices.returnPickedFile().then((_value) {
          setState(() {
            _imageSelected = _value;
          });
        });
      },
      child: () {
        if (_imageSelected != null) {
          return CustomRoundedImageFileWidget(
            file: _imageSelected!,
            key: UniqueKey(),
            size: _height * .20,
          );
        } else {
          return CustomRoundedImageWidget(
            key: UniqueKey(),
            size: _height * .20,
          );
          // added this line
        }
      }(),
    );
  }
}
