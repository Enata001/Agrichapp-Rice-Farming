import 'package:agrichapp/features/feature_authentication/models/user_data.dart';
import 'package:agrichapp/features/feature_videos/models/video_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../feature_videos/models/thumbnail.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  //E-mail Sign Up
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    VoidCallback? onFailure,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      onFailure?.call();
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
    Function(String error)? onFailure,
    Function? onSuccess,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      onSuccess?.call();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }
      onFailure?.call(e.code);
    }
  }

  // sign up with phone
  Future<void> phoneAuth({
    required String phone,
    void Function(FirebaseAuthException)? onVerificationFailed,
    void Function(String, int?)? onCodeSent,
    void Function(PhoneAuthCredential)? onVerificationCompleted,
  }) async {
    // FOR ANDROID, IOS
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        onVerificationCompleted?.call(credential);
      },
      verificationFailed: (e) {
        onVerificationFailed?.call(e);
      },
      codeSent: ((String verificationId, int? resendToken) async {
        onCodeSent?.call(verificationId, resendToken);
      }),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future signInWithCred({
    required String smsCode,
    int? token,
    required AuthCredential authCredential,
    required AuthCredential phoneAuthCredential,
    Function? onSuccess,
    VoidCallback? onError,
  }) async {
    var cred = await _auth.signInWithCredential(authCredential);
    if (cred.user != null) {
      await cred.user?.linkWithCredential(phoneAuthCredential);

      onSuccess?.call();
    } else {
      onError?.call();
    }
  }

  Future signInWithPhone(
      {required String smsCode,
      Function? onSuccess,
      VoidCallback? onError,
      required AuthCredential phoneAuthCredential}) async {
    var cred = await _auth.signInWithCredential(phoneAuthCredential);
    if (cred.user != null) {
      if (kDebugMode) {
        print(cred.user);
      }
      onSuccess?.call();
    } else {
      onError?.call();
    }
  }

  Future signOut({
    required Function onSuccess,
    VoidCallback? onError,
  }) async {
    if (kDebugMode) {
      print(_auth.currentUser);
    }
    await GoogleSignIn().signOut();
    await _auth.signOut();
    if (kDebugMode) {
      print(_auth.currentUser);
    }
    var state = _auth.currentUser;
    if (state == null) {
      onSuccess.call();
    } else {
      onError?.call();
    }
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    UserCredential user = await _auth.signInWithCredential(credential);

    if (user.user != null) {
      if (kDebugMode) {
        print(user.user);
      }
      Map<String, String> userInfo = {
        'username': user.user?.displayName ?? "",
        'email': user.user?.providerData[0].email ?? "",
      };
      // await user.user?.delete();
      return userInfo;
    }
  }

  Future checkUserFromMail(
      {required String email,
      required Function onDataFound,
      required VoidCallback noData}) async {
    final StoreMethods info = StoreMethods(FirebaseDatabase.instance);
    final userValue = await info.retrieveInfoFromMail(email: email);

    if (userValue == null) {
      noData.call();
    } else {
      onDataFound.call();
    }
  }

  Future checkUserFromPhone(
      {required String phone,
      required Function onDataFound,
      required VoidCallback noData}) async {
    final StoreMethods info = StoreMethods(FirebaseDatabase.instance);
    final userValue = await info.retrieveInfoFromPhone(phone: phone);
    if (userValue == null) {
      noData.call();
    } else {
      onDataFound.call();
    }

    if (userValue == null) {
      noData.call();
    } else {
      onDataFound.call();
    }
  }

  Future passwordReset({
    required String email,
    required Function onSuccess,
    Function(String error)? onFailure,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      onSuccess.call();
    } on FirebaseAuthException catch (e) {
      onFailure?.call(e.code);
    }
  }
}

class FireStoreMethods {
  final FirebaseFirestore _store;

  FireStoreMethods(this._store);

  Future addUserDetails(UserData user) async {
    await _store.collection('Users').add({
      "username": user.username,
      "password": user.password,
      "phone": user.phone,
      "email": user.email ?? "",
    });
  }
}

class StorageMethods {
  final FirebaseStorage _storage;

  StorageMethods(this._storage);

  Future<List<Video>> getVideosFromFolder(
      String folderName, List<Video> videos) async {
    Reference ref = _storage.ref(folderName);
    ListResult result = await ref.listAll();
    for (Reference fileRef in result.items) {
      String name = fileRef.name;
      String path = fileRef.fullPath;
      Video video = Video(name: name, path: path);
      videos.add(video);
    }
    return videos;
  }

  Future<List<Thumbnail>> getVideoListFromFolder(
      String folderName, List<Thumbnail> videos) async {
    Reference ref = _storage.ref().child('${folderName}Pics');
    ListResult result = await ref.listAll();
    for (Reference fileRef in result.items) {

      String name = fileRef.name;
      String path = await fileRef.getDownloadURL();
      Thumbnail video = Thumbnail(
        name: name,
        path: path,
        category: folderName,
      );
      videos.add(video);
    }
    return videos;
  }

  Future<String> getVideoFromFolder(String folderName, String name) async {
    final storageRef = _storage.ref().child(folderName).child('$name.mp4');
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }

  Future<String> getPic(String email, String filename) async {
    final storageRef = _storage.ref().child('Users').child('$email/$filename');
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }
}

class StoreMethods {
  final FirebaseDatabase _database;

  StoreMethods(this._database);

  Future saveUserDetails(UserData user) async {
    await _database
        .ref()
        .child('Users')
        .child((user.email?.replaceAll(".", "_")) ?? "test@example.com")
        .set({
      "username": user.username,
      "phone": user.phone,
      "password": user.password,
      "email": user.email ?? "",
    });
  }

  Future saveUserContacts(UserData user) async {
    await _database.ref().child('Contacts').set({
      user.phone: user.email?.replaceAll(".", "_"),
    });
  }

  Future retrieveEmail(String phone) async {
    DatabaseEvent event = await _database.ref('Contacts').child(phone).once();
    final userMail = event.snapshot.value.toString();
    return userMail;
  }

  Future retrieveInfoFromMail(
      {required String email, VoidCallback? onFailure}) async {
    try {
      DatabaseEvent event = await _database
          .ref('Users')
          .child(email.replaceAll(".", "_").trim())
          .once();
      final DataSnapshot userValue = event.snapshot;
      return userValue.value;
    } on FirebaseException {
      onFailure?.call();
    }
  }

  Future retrieveInfoFromPhone({required String phone}) async {
    DatabaseEvent event = await _database.ref('Contacts').child(phone).once();
    final userMail = event.snapshot.value.toString();
    if (userMail != "null") {
      final userDetails = await retrieveInfoFromMail(email: userMail);
      return userDetails;
    }
  }
}
