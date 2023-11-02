import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_authentication/screens/auth_screen.dart';
import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:agrichapp/features/feature_profile/screens/edit_profile.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late AuthProvider authProvider;
  late FirebaseAuthMethods firebaseAuth;
  late StorageMethods storageMethods;
  String path = "";
  String imagePath = "";

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    firebaseAuth = FirebaseAuthMethods(FirebaseAuth.instance);
    storageMethods = StorageMethods(FirebaseStorage.instance);

    getLink();

    super.initState();
  }

  Future<void> getLink() async {
    try{
      path = await storageMethods.getPic(
          authProvider.userData!.email!.replaceAll('.', '_').toString(),
          'user_profile_pic');
    } on FirebaseException{
      setState(() {
        imagePath="";
      });
    }
    setState(() {
      imagePath = path;
    });
  }

  final TextStyle style = const TextStyle(
    color: AppColors.forestGreen,
    fontSize: 16,
  );

  bool confirmPassword() {
    bool isVisible = false;
    bool isCorrect = false;
    void showPassword() {
      setState(() {
        isVisible = !isVisible;
      });
    }

    showAdaptiveDialog(
        context: context,
        builder: (builder) {
          String password = "";
          return AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            insetPadding: EdgeInsets.zero,
            actionsPadding: const EdgeInsets.symmetric(vertical: 5),
            // titlePadding: const EdgeInsets.only(bottom: 5),
            buttonPadding: EdgeInsets.zero,
            title: const Text(
              'Enter Password',
              style: TextStyle(fontSize: 18, color: AppColors.forestGreen),
            ),
            content: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: TextField(
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: !isVisible,

                onChanged: (value) {
                  password = value;
                  if (kDebugMode) {
                    print(password);
                  }
                },

                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColors.forestGreen,
                    ),
                    helperText: isCorrect ? "": "Incorrect Password",
                    suffixIcon: IconButton(
                      onPressed: showPassword,
                      icon: isVisible
                          ? const Icon(
                              Icons.visibility_outlined,
                              color: AppColors.forestGreen,
                            )
                          : const Icon(
                              Icons.visibility_off_outlined,
                              color: AppColors.forestGreen,
                            ),
                    ),
                    labelText: "Password"),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: style,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text(
                    'OK',
                    style: style,
                  ),
                  onPressed: () {
                    if (password == authProvider.userData?.password) {
                      isCorrect = true;
                    }
                  }),
            ],
          );
        });
    return isCorrect;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 35, bottom: 25),
          child: Text(
            'Profile',
            style: Theme.of(context).textTheme.titleLarge,
            textScaleFactor: 0.8,
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "@${authProvider.userData!.username ?? 'User'}",
            style: Theme.of(context).textTheme.headlineSmall,
            textScaleFactor: 0.8,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(30),
          child: ElevatedButton(
            onPressed: () {
              // bool isCorrect = confirmPassword();
              // if (isCorrect) {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const EditProfile(),
                    type: PageTransitionType.fade,
                    ctx: context,
                    // childCurrent: this,
                  ),
                );
              // }else {
              //   return;
              // }

            },
            child: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.05,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          trailing: const Icon(Icons.arrow_forward_outlined),
          onTap: () {
            // print('the logout button has been clicked');
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Log Out?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                content: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                              );
                            },
                          );
                          await firebaseAuth.signOut(
                            onSuccess: () {
                              Navigator.of(context).pop();
                              authProvider.clearUserInfo();
                              authProvider.clearVideoInfo();
                              authProvider.clearTips();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                      child: const AuthScreen(),
                                      type: PageTransitionType.size,
                                      alignment: Alignment.bottomRight),
                                  (route) => false);
                            },
                            onError: () {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return const AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "Something went wrong. Please try again later"),
                                    );
                                  });
                            },
                          );
                        },
                        child: Text(
                          "Yes",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "No",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
