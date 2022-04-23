//packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//provider
import '../providers/authentication_provider.dart';
import '../providers/user_screen_provider.dart';

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
  late UserScreenProvider _userScreenProvider;
  final TextEditingController _searchFieldTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserScreenProvider>(
            create: (_) => UserScreenProvider(_auth)),
      ],
      child: _actualUi(),
    );
  }

  Widget _actualUi() {
    return Builder(builder: (BuildContext _context) {
      _userScreenProvider = _context.watch<UserScreenProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: _width * 0.03, vertical: _height * 0.02),
        height: _height * 0.98,
        width: _width * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBarWidget("Users"),
            CustomSearchTextField(
              controller: _searchFieldTextController,
              isObscured: false,
              hintText: "Search...",
              icon: Icons.search,
              onEditingComplete: (_value) {
                _userScreenProvider.getUsers(name: _value);
                FocusScope.of(context).unfocus();
              },
            ),
            _searchedUserList(),
            _createNewConversation(),
          ],
        ),
      );
    });
  }

  Widget _searchedUserList() {
    List<ChatUser>? _search = _userScreenProvider.users;
    return Expanded(
      child: () {
        if (_search != null) {
          if (_search.isNotEmpty) {
            return ListView.builder(
              itemCount: _search.length,
              itemBuilder: (context, _idx) {
                print(_search[_idx].lastSeen.difference(DateTime.now()).inDays);
                return CustomListViewTileSearchUser(
                  height: _height * .10,
                  title: _search[_idx].name,
                  subTitle: _search[_idx]
                              .lastSeen
                              .difference(DateTime.now())
                              .inDays >
                          -9
                      ? _search[_idx]
                                  .lastSeen
                                  .difference(DateTime.now())
                                  .inMinutes >
                              -2
                          ? "Active Now"
                          : _search[_idx]
                                      .lastSeen
                                      .difference(DateTime.now())
                                      .inDays >=
                                  -1
                              ?-1* _search[_idx]
                                          .lastSeen
                                          .difference(DateTime.now())
                                          .inMinutes >
                                      59
                                  ? "Last Active: ${_search[_idx].lastHrsActive()}"
                                  : "Last Active: ${_search[_idx].lastMinuteActive()}"
                              : "Last Active: ${_search[_idx].lastDayActive()}"
                      : "Last Active: Long Ago",
                  imagePath: _search[_idx].imageURL,
                  isActive: _search[_idx].wasRecentlyActive(),
                  isSelected:
                      _userScreenProvider.selectedUsers.contains(_search[_idx]),
                  onPress: () {
                    _userScreenProvider.updateSelectedUser(_search[_idx]);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No Users Found 🚫",
                style: TextStyle(
                  color: textColor,
                ),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: appMainColor,
            ),
          );
        }
      }(),
    );
  }

  Widget _createNewConversation() {
    return Visibility(
      visible: _userScreenProvider.selectedUsers.isNotEmpty &&
          _userScreenProvider.selectedUsers
              .where((_element) => _element.uid == _auth.user.uid)
              .isEmpty,
      child: CustomRoundedButton(
        height: _height * 0.08,
        name: _userScreenProvider.selectedUsers.length == 1
            ? "Chat with ${_userScreenProvider.selectedUsers.first.name}"
            : "Create group chat",
        onPressed: () {
          _userScreenProvider.createConversation();
        },
        width: _height * .80,
      ),
    );
  }
}
