//packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGE_COLLECTION = "Messages";

class DataBaseServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DataBaseServices() {}

  // to retrieve current user data
  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db
          .collection(USER_COLLECTION)
          .doc(_uid)
          .update({"last_active": DateTime.now().toUtc()});
    } catch (e) {
      print(e);
    }
  }
}
