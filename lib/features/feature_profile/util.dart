import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file == null) {
    return;
  }
  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  const imageName = 'user_profile_pic.png';

  List info= [File(file.path), imageName, file.path];
  return  info;
}

Future uploadPicture(String email, File image) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  String filename = "user_profile_pic";
  final storageRef =
  storage.ref().child('Users').child('$email/$filename');
  final uploadTask = await storageRef.putFile(image);
  String downloadUrl = await storageRef.getDownloadURL();
  return downloadUrl;
}

Future clearPicture(String email) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  String filename = "user_profile_pic";
  final storageRef =
  storage.ref().child('Users').child('$email/$filename');
  String downloadUrl = await storageRef.getDownloadURL();
  if (kDebugMode) {
    print(downloadUrl);
  }
  await storageRef.delete();
  if (downloadUrl.isEmpty){
  return;
  }

}