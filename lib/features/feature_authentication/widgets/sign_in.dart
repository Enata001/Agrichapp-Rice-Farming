import 'package:agrichapp/features/feature_authentication/models/user_data.dart';
import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_authentication/screens/forgot_password.dart';
import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../feature_dashboard/screens/dashboard.dart';
import '../models/otp_screen_data.dart';
import '../screens/otp_screen.dart';
import 'google_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isActive = false;
  bool isVisible = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FirebaseAuthMethods firebaseAuthMethods;
  late AuthProvider authProvider;
  late StoreMethods storeMethods;

  void _showPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  // void _rememberMe(bool value) {
  //   setState(() {
  //     isActive = value;
  //   });
  // }

  // String hashPassword(String password) {
  //   var salt = 'the_gods_must_be_crazy';
  //   var saltedPassword = salt + password;
  //   var bytes = utf8.encode(saltedPassword);
  //   var hash = sha256.convert(bytes);
  //   return hash.toString();
  // }

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    storeMethods = StoreMethods(FirebaseDatabase.instance);
    emailController = TextEditingController();
    passwordController = TextEditingController();
    firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  nextPage() {
    Navigator.of(context).pop();
    Navigator.push(
      context,
      PageTransition(
          child: const DashBoard(),
          type: PageTransitionType.size,
          alignment: Alignment.bottomRight),
    );
  }

  progress() {
    showAdaptiveDialog(
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

  final TextStyle style = const TextStyle(
    color: AppColors.forestGreen,
    fontSize: 16,
  );

  phoneSignIn() {
    showAdaptiveDialog(
        context: context,
        builder: (builder) {
          String phoneNumber = "";
          return AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            insetPadding: EdgeInsets.zero,
            actionsPadding: const EdgeInsets.symmetric(vertical: 5),
            // titlePadding: const EdgeInsets.only(bottom: 5),
            buttonPadding: EdgeInsets.zero,
            title: const Text(
              'Enter Phone Number',
              style: TextStyle(fontSize: 18, color: AppColors.forestGreen),
            ),
            content: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.85,
              child: IntlPhoneField(
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: const InputDecoration(
                  helperText: "",
                  // errorText: "",
                  counterText: "",
                  // labelText: 'Phone Number',
                  hintText: "Phone Number",
                  hintStyle: TextStyle(color: AppColors.forestGreen),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                keyboardType: TextInputType.number,
                initialCountryCode: 'GH',
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                },
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
                onPressed: () async {
                  if (phoneNumber.isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop();
                  progress();

                  final info = await storeMethods.retrieveInfoFromPhone(
                      phone: phoneNumber);

                  if (info != null) {
                    Map<String, dynamic> information =
                        Map<String, dynamic>.from(info as Map);
                    UserData user = UserData.fromString(
                        data:
                            '{"email": "${information['email']}", "phone": "${information['phone']}", "password":"${information['password']}", "username":"${information['username']}" } ');

                    await firebaseAuthMethods.phoneAuth(
                      phone: user.phone ?? "",
                      onVerificationFailed: (e) {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: Text(e.message ?? "Verification failed"),
                            );
                          },
                        );
                      },
                      onCodeSent: (
                        verificationId,
                        resendToken,
                      ) {
                        Navigator.of(context).pop();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OneTimePinScreen(
                              otpScreenData: OtpScreenData(
                                user: user,
                                verificationId: verificationId,
                                screen: 2,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    response('Account Not Found', "");
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(
                    Icons.mail,
                    color: AppColors.forestGreen,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                maxLines: 1,
                controller: passwordController,
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: !isVisible,
                decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: AppColors.forestGreen,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _showPassword,
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    return response(
                        "Error", "Please fill all fields as required");
                  }
                  progress();

                  await firebaseAuthMethods.checkUserFromMail(
                      email: emailController.text.trim(),
                      noData: () {
                        Navigator.of(context).pop();
                        response("Account Not Found", "");
                      },
                      onDataFound: () async {
                        await firebaseAuthMethods.signInWithEmail(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            onSuccess: () async {
                              final info =
                                  await storeMethods.retrieveInfoFromMail(
                                      email: emailController.text.trim());
                              Map<String, dynamic> information =
                                  Map<String, dynamic>.from(info as Map);
                              UserData user = UserData.fromString(
                                  data:
                                      '{"email": "${emailController.text}", "phone": "${information['phone']}", "password":"${passwordController.text}", "username":"${information['username']}" } ');
                              await authProvider
                                  .saveUserinfo(user: user)
                                  .then((value) {
                                setState(() {
                                  authProvider.userData = user;
                                });
                              });
                              return nextPage();
                            },
                            onFailure: (error) {
                              Navigator.of(context).pop();
                              return response("Error", "Incorrect Password");
                            });
                      });
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>const ResetPassword()));
                },
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const Row(
              children: [
                Expand(),
                Text(
                  "Or",
                  textScaleFactor: 1.5,
                ),
                Expand()
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: phoneSignIn,
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text(
                  "Sign in with Phone",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            // GoogleButton(
            //   title: "Sign in with google",
            //   action: () async {
            //     progress();
            //     final userCred = await firebaseAuthMethods.signInWithGoogle();
            //     if (userCred != null) {
            //       final email = userCred['email'];
            //       await firebaseAuthMethods.checkUserFromMail(
            //           email: email,
            //           noData: () {
            //             Navigator.of(context).pop();
            //             response("Account Not Found", "");
            //           },
            //           onDataFound: () async {
            //             await firebaseAuthMethods.signOut(
            //                 onSuccess: () async {});
            //             final info = await storeMethods.retrieveInfoFromMail(
            //                 email: email);
            //             Map<String, dynamic> information =
            //                 Map<String, dynamic>.from(info as Map);
            //             await firebaseAuthMethods.signInWithEmail(
            //                 email: email,
            //                 password: information['password'],
            //                 onSuccess: () async {
            //                   UserData user = UserData.fromString(
            //                       data:
            //                           '{"email": "${information['email']}", "phone": "${information['phone']}", "password":"${information['password']}", "username":"${information['username']}" } ');
            //                   await authProvider
            //                       .saveUserinfo(user: user)
            //                       .then((value) {
            //                     setState(() {
            //                       authProvider.userData = user;
            //                     });
            //                   });
            //                   return nextPage();
            //                 },
            //                 onFailure: (error) {
            //                   Navigator.of(context).pop();
            //                   return response("Error", "Incorrect Password");
            //                 });
            //           });
            //
            //     } else {
            //       Navigator.of(context).pop();
            //       response("Error", "Sign in Failed. Please try again");
            //     }
            //
            //     // nextPage();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class Expand extends StatelessWidget {
  const Expand({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        thickness: 2,
        color: Theme.of(context).primaryColorLight,
        indent: 10,
        endIndent: 10,
      ),
    );
  }
}
