//packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGE_COLLECTION = "Messages";

class DataBaseServices{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  DataBaseServices(){}
}