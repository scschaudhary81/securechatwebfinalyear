import 'dart:io';

//packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";

class CloudStorageServices {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  CloudStorageServices() {}

  Future<String?> saveUserImageToStorage(
      String _uid, PlatformFile _file) async {
    try {
      Reference _ref = _firebaseStorage
          .ref()
          .child('images/users/$_uid/profile.${_file.extension}');
      // add for the web here
      UploadTask _task = _ref.putFile(File(_file.path!));
      return _task.then((_result) => _result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImageFirebaseStorage(
      String _chatId, String _uid, PlatformFile _file) async {
    try {
      Reference _ref = _firebaseStorage.ref().child(
          'images/chats/$_chatId/${_uid}_${Timestamp.now().microsecondsSinceEpoch}.${_file.extension}');
      // add for the web
      UploadTask _task = _ref.putFile(File(_file.path!));
      return _task.then((_result) => _result.ref.getDownloadURL());
    } catch (e) {
      print(e);
    }
  }
}
