import './chat_user.dart';
import './chat_message.dart';

class Chat {
  final String uid;
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recepients;

  Chat(
      {required this.uid,
      required this.currentUserUid,
      required this.activity,
      required this.group,
      required this.members,
      required this.messages}) {
    _recepients = members.where((_i) => _i.uid != currentUserUid).toList();
  }

  List<ChatUser> recepients() {
    return _recepients;
  }

  String title() {
    return !group
        ? _recepients.first.name
        : _recepients.map((_user) => _user.name).join(" ,");
  }

  String groupImageUrl() {
    return group
        ? "https://images.unsplash.com/photo-1470753323753-3f8091bb0232?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80"
         :_recepients.first.imageURL;
  }
}
