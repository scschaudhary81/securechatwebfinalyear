//packages
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

//services
import '../services/database_services.dart';
import '../services/navigation_services.dart';

//providers
import '../providers/authentication_provider.dart';

//modals
import '../modals/chat_user.dart';
import '../modals/chat.dart';

//screen
import '../screens/conversation_screen.dart';

class UserScreenProvider extends ChangeNotifier {
  AuthenticationProvider _auth;
  late DataBaseServices _db;
  late NavigationServices _navigation;

  List<ChatUser>? _users;
  late List<ChatUser> _selectedUsersFromSearchedUsers;

  List<ChatUser> get selectedUsers {
    return _selectedUsersFromSearchedUsers;
  }

  List<ChatUser>? get users {
    return _users;
  }

  UserScreenProvider(this._auth) {
    _selectedUsersFromSearchedUsers = [];
    _db = GetIt.instance.get<DataBaseServices>();
    _navigation = GetIt.instance.get<NavigationServices>();
    getUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getUsers({String? name}) async {
    _selectedUsersFromSearchedUsers = [];
    try {
      _db.searchUsers(name: name).then((_snapshot) {
        _users = _snapshot.docs.map((_doc) {
          Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;
          _data["uid"] = _doc.id;
          return ChatUser.fromJSON(_data);
        }).toList();
        notifyListeners();
      });
    } catch (e) {
      print("Error fetching users from the data base");
      print(e);
    }
  }

  void updateSelectedUser(ChatUser _user) {
    if (_selectedUsersFromSearchedUsers.contains(_user)) {
      _selectedUsersFromSearchedUsers.remove(_user);
    } else {
      _selectedUsersFromSearchedUsers.add(_user);
    }
    notifyListeners();
  }

  void createConversation() async {
    try {
      //create chat
      if (_selectedUsersFromSearchedUsers.length == 0) return;
      List<String> _memberIDS =
          _selectedUsersFromSearchedUsers.map((_e) => _e.uid).toList();
      _memberIDS.add(_auth.user.uid);
      bool _isGroup = _selectedUsersFromSearchedUsers.length > 1;
      DocumentReference? _ref = await _db.createChat({
        "is_group": _isGroup,
        "is_activity": false,
        "members": _memberIDS,
      });
      //navigate to conversation screen
      List<ChatUser> _members = [];
      for (var _i in _memberIDS) {
        DocumentSnapshot _userSnapshots = await _db.getUser(_i);
        Map<String, dynamic> _userData =
            _userSnapshots.data() as Map<String, dynamic>;
        _userData["uid"] = _userSnapshots.id;
        _members.add(
          ChatUser.fromJSON(_userData),
        );
      }
      ConverationScreen _page = ConverationScreen(
        chat: Chat(
          uid: _ref!.id,
          currentUserUid: _auth.user.uid,
          members: _members,
          messages: [],
          activity: false,
          group: _isGroup,
        ),
      );
      _selectedUsersFromSearchedUsers = [];
      notifyListeners();
      _navigation.navigateToPage(_page);
    } catch (e) {
      print("Error creating new conversation");
      print(e);
    }
  }
}
