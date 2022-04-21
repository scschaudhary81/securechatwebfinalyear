//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//provider
import '../providers/authentication_provider.dart';

//widget
import '../widgets/top_bar_widget.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles_user_group.dart';
import '../widgets/custom_rounded_button.dart';

//services
import '../services/database_services.dart';

//modals
import '../modals/chat_user.dart';

//constants
import '../constants.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late double _height;
  late double _width;
  late AuthenticationProvider _auth;
  final TextEditingController _searchFieldTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return _actualUi();
  }

  Widget _actualUi() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: _width * 0.03, vertical: _height * 0.02),
      height: _height*0.98,
      width: _width*0.97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TopBarWidget("Users"),
        ],
      ),
    );
  }
}
