//packages
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
  PlatformFile? _imageSelected;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return _actualUi();
  }

  Widget _actualUi() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
          ],
        ),
      ),
    );
  }

  Widget _profilePicture() {
    if (_imageSelected != null) {
      return Container();
    } else {
      return CustomRoundedImageWidget(
        key: UniqueKey(),
        imagePath: "https://i.pravatar.cc/300",
        size: _height * .15,
      );
      // added this line
    }
  }
}
