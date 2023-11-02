import 'dart:convert';
// import 'package:agrichapp/features/feature_authentication/models/user_data.dart';
import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:agrichapp/features/feature_profile/util.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../feature_authentication/models/user_data.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late AuthProvider authProvider;
  late StoreMethods storeMethods;
  late StorageMethods storageMethods;
  late FirebaseAuthMethods firebaseAuthMethods;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  String path = "";
  List? information;
  bool isVisible = false;
  String imagePath = "";

  selectImage(ImageSource source) async {
    List info = await pickImage(source);
    if (kDebugMode) {
      print(info);
    }
    imagePath = await uploadPicture(
        authProvider.userData!.email!.replaceAll('.', '_').toString(), info[0]);
    setState(() {
      imagePath = imagePath;
    });
    if (kDebugMode) {
      print("This is the image path");
      print(imagePath);
    }
  }

  // void _showPassword() {
  //   setState(() {
  //     isVisible = !isVisible;
  //   });
  // }

  selectSource() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            height: MediaQuery.sizeOf(context).height * 0.3,
            decoration:
                const BoxDecoration(borderRadius: BorderRadius.horizontal()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Select an option:",
                  textScaleFactor: 1.3,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: AppColors.forestGreen,
                  ),
                  title: const Text("Camera"),
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.image, color: AppColors.forestGreen),
                  title: const Text("Gallery"),
                  onTap: () {
                    selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.clear),
                  title: const Text("Clear Profile Picture"),
                  textColor: Colors.red.withOpacity(0.8),
                  onTap: () async{
                 await clearPicture(authProvider.userData!.email!.replaceAll('.', '_').toString());
                 Navigator.of(context).pop();

                 imagePath = '';
                 setState(() {

                 });

                  },
                ),
              ],
            ),
          );
        });
  }

  String hashPassword(String password) {
    var salt = 'the_gods_must_be_crazy';
    var saltedPassword = salt + password;
    var bytes = utf8.encode(saltedPassword);
    var hash = sha256.convert(bytes);
    return hash.toString();
  }

  progress() {
    showDialog(
      context: context,
      builder: (builder) {
        return const Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              color: AppColors.forestGreen,
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    storeMethods = StoreMethods(FirebaseDatabase.instance);
    firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
    storageMethods = StorageMethods(FirebaseStorage.instance);
    emailController = TextEditingController(text: authProvider.userData?.email);
    phoneController = TextEditingController(text: authProvider.userData?.phone);
    usernameController = TextEditingController(text: authProvider.userData?.username);

    getLink();

    super.initState();
  }



  response(String title, String info) {
    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: 60,
          height: 60,
          child: Center(
            child: AlertDialog(
              title: Text(
                title,
                textAlign: TextAlign.center,
                textScaleFactor: 0.7,
              ),
              content: Text(
                info,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> getLink() async {

    try{
    path = await storageMethods.getPic(
        authProvider.userData!.email!.replaceAll('.', '_').toString(),
        'user_profile_pic');
    } on FirebaseException{
      return;
    }
    setState(() {
      imagePath = path;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void updateInfo() async {
    progress();
    if (usernameController.text.isEmpty || phoneController.text.isEmpty) {
      return;
    }
    UserData user = UserData(
      phone: phoneController.text.trim(),
      password: "",
      username: usernameController.text.trim(),
      email: authProvider.userData!.email,
    );
    //
    await storeMethods.saveUserDetails(user);

    await authProvider.saveUserinfo(user: user).then((value) {

      Navigator.of(context).pop();
      response("Success", "User data updated successfully");

      setState(() {
        authProvider.userData = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: double.infinity,
          width: double.infinity,
          decoration: context.background,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.01,
                  ),
                  SizedBox(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 96,
                            backgroundColor: AppColors.profileColour,
                            backgroundImage: imagePath.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    imagePath,
                                  )
                                : null,
                            child: imagePath.isEmpty
                                ? Text(
                                    authProvider.userData!.username
                                            ?.substring(0, 1)
                                            .toUpperCase() ??
                                        'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    textScaleFactor: 2,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 3,
                          child: GestureDetector(
                            onTap: selectSource,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/addphoto.png'),
                              radius: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Text(
                      authProvider.userData?.email ?? "User",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textScaleFactor: 0.8,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      controller: usernameController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: TextField(
                      readOnly: true,
                      onTap: () {},
                      maxLines: 1,
                      controller: emailController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: TextField(
                      maxLines: 1,
                      controller: phoneController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(),
                    child: ElevatedButton(

                      onPressed: () async {
                        updateInfo();
                        // Navigator.of(context).pop();
                        // await getLink();
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
