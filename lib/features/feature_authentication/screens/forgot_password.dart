import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email = "";
  late FirebaseAuthMethods firebaseAuthMethods;

  @override
  void initState() {
    firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
    super.initState();
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: Theme.of(context).textTheme.titleLarge,
          textScaleFactor: 0.8,
        ),
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: context.background,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Enter your email and we will send you a password reset link",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
                textScaleFactor: 0.7,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.mail,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: 50,
                child: MaterialButton(
                  color: AppColors.forestGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                    if (email.isEmpty) {
                      return response(
                          "Error", "Please fill all fields as required");
                    }
                    progress();
                    await firebaseAuthMethods.checkUserFromMail(
                      email: email,
                      noData: () {
                        Navigator.of(context).pop();
                        response("Account Not Found", "");
                      },
                      onDataFound: () async {
                        firebaseAuthMethods.passwordReset(
                            email: email,
                            onSuccess: () {
                              response('Success',
                                  "Password reset link has been sent to your email");
                            },
                            onFailure: (val) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

                              response("Error", "Error Occurred");

                              return;
                            });
                      },
                    );
                  },
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
