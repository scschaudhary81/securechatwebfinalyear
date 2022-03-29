import 'dart:io';
//packages
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


const String  USER_COLLECTION = "Users";

class CloudStorageServices{
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  CloudStorageServices(){}
}