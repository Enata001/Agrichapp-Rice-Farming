import 'package:agrichapp/features/feature_authentication/models/user_data.dart';
import 'package:agrichapp/features/feature_authentication/screens/otp_screen.dart';
import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:agrichapp/features/feature_authentication/widgets/google_button.dart';
import 'package:agrichapp/features/feature_authentication/widgets/sign_in.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../models/otp_screen_data.dart';
import '../providers/auth_provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignInState();
}

class _SignInState extends State<SignUp> {
  bool isAgreed = false;
  bool isVisible = false;
  bool isAlsoVisible = false;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late FirebaseAuthMethods firebaseAuthMethods;
  late AuthProvider authProvider;
  late StoreMethods storeMethods;
  String number = "";
  String confirmation = "";

  void _showPassword() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  void _showConfirmPassword() {
    setState(() {
      isAlsoVisible = !isAlsoVisible;
    });
  }

  void _agreement(bool value) {
    setState(() {
      isAgreed = value;
    });
  }

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    storeMethods = StoreMethods(FirebaseDatabase.instance);
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                controller: usernameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: AppColors.forestGreen,
                  ),
                  labelText: "Username",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail,
                    color: AppColors.forestGreen,
                  ),
                  labelText: "E-mail",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: TextField(
                controller: passwordController,
                maxLines: 1,
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
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: TextField(
                controller: confirmPasswordController,
                maxLines: 1,
                onChanged: (value) {
                  setState(() {
                    confirmation = value;
                  });
                  // if(passwordController.text.trim() !=){
                  //
                  // }
                },
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: !isAlsoVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: AppColors.forestGreen,
                  ),
                  suffixIcon: IconButton(
                    onPressed: _showConfirmPassword,
                    icon: isAlsoVisible
                        ? const Icon(
                            Icons.visibility_outlined,
                            color: AppColors.forestGreen,
                          )
                        : const Icon(
                            Icons.visibility_off_outlined,
                            color: AppColors.forestGreen,
                          ),
                  ),
                  labelText: "Confirm Password",
                  helperText: passwordController.text.trim() !=
                          confirmPasswordController.text.trim()
                      ? "Passwords don't match"
                      : "",
                  helperStyle: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            IntlPhoneField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(
                helperText: "",
                // errorText: "",
                counterText: "",
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              keyboardType: TextInputType.number,
              initialCountryCode: 'GH',
              onChanged: (phone) {
                number = phone.completeNumber;
              },
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Container(
              margin: const EdgeInsets.only(
                right: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: isAgreed,
                    onChanged: (value) => _agreement(value!),
                    checkColor: Theme.of(context).primaryColor,
                    activeColor: Colors.white,
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const Text("I Agree to the Terms and Conditions.")
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      usernameController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      confirmPasswordController.text.isEmpty ||
                      number.isEmpty) {
                    return response(
                        "Error", "Please fill all fields as required");
                  }

                  if (passwordController.text.trim() !=
                      confirmPasswordController.text.trim()) {
                    return response("Error", "Passwords don't match");
                  }

                  if (isAgreed == false) {
                    return response(
                        "Please Agree to the Terms and Conditions", "");
                  }

                  UserData user = UserData(
                    phone: number,
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    username: usernameController.text.trim(),
                  );

                  progress();

                  await firebaseAuthMethods.checkUserFromMail(
                    email: emailController.text.trim(),
                    onDataFound: () {
                      Navigator.of(context).pop();
                      response("Account Already Exists",
                          "Please Sign in or Use Different Credentials");
                      return;
                    },
                    noData: () async {
                      await firebaseAuthMethods.phoneAuth(
                        phone: user.phone ?? "",
                        onVerificationFailed: (e) {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content:
                                    Text(e.message ?? "Verification failed"),
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
                                  screen: 1,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            // const Row(
            //   children: [
            //     Expand(),
            //     Text(
            //       "Or",
            //       textScaleFactor: 1.5,
            //     ),
            //     Expand(),
            //   ],
            // ),
            // GoogleButton(
            //     title: "Continue with Google",
            //     action: () async {
            //       final userCred = await firebaseAuthMethods.signInWithGoogle();
            //       if (userCred != null) {
            //         if (kDebugMode) {
            //           print(userCred);
            //         }
            //         setState(() {
            //           usernameController.text = userCred['username'];
            //           emailController.text = userCred['email'];
            //         });
            //         await firebaseAuthMethods.signOut(onSuccess: () {
            //           Navigator.of(context).pop;
            //         });
            //       } else {
            //         Navigator.of(context).pop();
            //         response("Error", "Sign in Failed. Please try again");
            //       }
            //     }),
          ],
        ),
      ),
    );
  }
}
