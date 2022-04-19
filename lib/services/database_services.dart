//packages
import 'package:cloud_firestore/cloud_firestore.dart';

//modals
import '../modals/chat_message.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGE_COLLECTION = "messages";

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

  Future<void> updateUserLastSeenToHideTime(String _uid) async {
    try {
      await _db
          .collection(USER_COLLECTION)
          .doc(_uid)
          .update({"last_active": DateTime.now().toUtc()});
    } catch (e) {
      print(e);
    }
  }

  Future<String> getUserFromUid(String _uid) async {
    String toReturn = "";
    await _db.collection(USER_COLLECTION).doc(_uid).get().then(
      (_data) {
        if (_data.exists) {
          Map<String, dynamic> userData = _data.data()! as Map<String, dynamic>;
          String name = userData["name"];
          toReturn = name;
        }
      },
    );
    return toReturn;
  }

  Future<void> enterNewUserDataInDataBase(
      String _uid, String _email, String _name, String _imageURL) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set(
        {
          "email": _email,
          "image": _imageURL,
          "name": _name,
          "last_active": DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getChatForUsers(String uid) {
    // to return all the chats in which the given user is involved in
    return _db
        .collection(CHAT_COLLECTION)
        .where("members", arrayContains: uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessage(String _chatId) async {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesFoChat(String _chatId) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatId)
        .collection(MESSAGE_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }
  Stream<DocumentSnapshot> streamIsActivity(String _chatID){
    return _db.collection(CHAT_COLLECTION).doc(_chatID).snapshots();
  }

  Future<void> deleteChat(String _chatId) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatId).delete();
    } catch (e) {
      print("deleting chat conversation unsucessfully");
      print(e);
    }
  }

  Future<void> deleteMessage(String _chatId, String content, String type,
      String sender_id, DateTime sent_time) async {
    try {
      String? id;
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGE_COLLECTION)
          .where("sent_time", isEqualTo: sent_time.toUtc())
          .where("sender_id", isEqualTo: sender_id)
          .where("content", isEqualTo: content)
          .where("type", isEqualTo: type)
          .get()
          .then((_value) {
        if (_value != null) {
          if (_value.docs.isNotEmpty) {
            id = _value.docs.first.id;
          }
        }
      });
      if (id != null) {
        await _db
            .collection(CHAT_COLLECTION)
            .doc(_chatId)
            .collection(MESSAGE_COLLECTION)
            .doc(id)
            .delete();
      }
    } catch (e) {
      print("error deleting message");
      print(e);
    }
  }

  Future<void> addMessageToChat(
      String _chatId, ChatMessage _chatMessage) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGE_COLLECTION)
          .add(_chatMessage.jsonChatMessage());
    } catch (e) {
      print("Error sending the message");
      print(e);
    }
  }

  Future<void> deleteParticularMessageInAChat(
      String _chatId, String _messageId) async {
    try {
      await _db
          .collection(CHAT_COLLECTION)
          .doc(_chatId)
          .collection(MESSAGE_COLLECTION)
          .doc(_messageId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(
      String _chatId, Map<String, dynamic> _chatData) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatId).update(_chatData);
    } catch (e) {
      print(e);
    }
  }
}
