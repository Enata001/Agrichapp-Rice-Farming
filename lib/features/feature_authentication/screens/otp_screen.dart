import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_authentication/services/firebase_auth_methods.dart';
import 'package:agrichapp/features/feature_dashboard/screens/dashboard.dart';
import 'package:agrichapp/resources/app_colours.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../models/otp_screen_data.dart';

class OneTimePinScreen extends StatefulWidget {
  const OneTimePinScreen({super.key, this.otpScreenData});

  final OtpScreenData? otpScreenData;

  @override
  State<OneTimePinScreen> createState() => _OneTimePinScreenState();
}

class _OneTimePinScreenState extends State<OneTimePinScreen> {
  late AuthProvider authProvider;
  late TextEditingController controller;
  late FocusNode focusNode;
  late FirebaseAuthMethods firebaseAuthMethods;
  late StoreMethods storage;
  String smsCode = "";

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    firebaseAuthMethods = FirebaseAuthMethods(FirebaseAuth.instance);
    storage = StoreMethods(FirebaseDatabase.instance);
    authProvider = context.read<AuthProvider>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void updateInfo() {
    authProvider.saveUserinfo(user: widget.otpScreenData!.user).then((value) {
      setState(() {
        authProvider.userData = widget.otpScreenData?.user;
      });
    });
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
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 65,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: const Border.fromBorderSide(
          BorderSide(
            color: AppColors.clearGreen,
          ),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: context.background,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.06),
                child: Text(
                  'Agrich 1.0',
                  style: Theme.of(context).textTheme.titleLarge,
                  textScaleFactor: 1.2,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.14,
              ),
              Text(
                'OTP Verification',
                style: Theme.of(context).textTheme.titleMedium,
                textScaleFactor: 1.5,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              ),
              Text(
                "Enter the code from the sms we sent to ${widget.otpScreenData?.user.phone}",
                textAlign: TextAlign.center,
                textScaleFactor: 1.05,
                style: const TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.06,
              ),
              Pinput(
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                length: 6,
                controller: controller,
                focusNode: focusNode,
                separatorBuilder: (index) => Container(
                  height: 64,
                  width: 1,
                  color: Colors.white,
                  margin: const EdgeInsets.only(right: 5),
                ),
                defaultPinTheme: defaultPinTheme,
                showCursor: true,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.forestGreen),
                    ),
                  ),
                ),
                onChanged: (value) {
                  smsCode = value;
                },
                closeKeyboardWhenCompleted: true,
                onCompleted: (_) async {
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
                      });
                  if (widget.otpScreenData?.screen == 1) {
                    await firebaseAuthMethods
                        .signUpWithEmail(
                            email: widget.otpScreenData!.user.email ??
                                "test@example.com",
                            password: widget.otpScreenData!.user.password ?? "",
                            onFailure: () {
                              response("Error", "Error");
                            })
                        .whenComplete(() async {
                      await firebaseAuthMethods.signInWithCred(
                        smsCode: smsCode,
                        authCredential: EmailAuthProvider.credential(
                            email: widget.otpScreenData?.user.email ??
                                "test@example.com",
                            password:
                                widget.otpScreenData?.user.password ?? ""),
                        phoneAuthCredential: PhoneAuthProvider.credential(
                          verificationId: widget.otpScreenData!.verificationId,
                          smsCode: smsCode,
                        ),
                        onSuccess: () async {
                          if (!mounted) return;
                          storage.saveUserDetails(widget.otpScreenData!.user);
                          storage.saveUserContacts(widget.otpScreenData!.user);
                          updateInfo();
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                  child: const DashBoard(),
                                  type: PageTransitionType.size,
                                  alignment: Alignment.bottomRight),
                              (route) => false);
                        },
                        onError: () {
                          if (!mounted) return;
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("Error"),
                                content: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Text("Error occurred"),
                                ),
                              );
                            },
                          );
                        },
                      );
                    });
                  }
                  if (widget.otpScreenData?.screen == 2) {
                    await firebaseAuthMethods.signInWithPhone(
                        smsCode: smsCode,
                        phoneAuthCredential: PhoneAuthProvider.credential(
                            verificationId:
                                widget.otpScreenData!.verificationId,
                            smsCode: smsCode),
                      onSuccess: () async {
                        if (!mounted) return;
                        updateInfo();
                        Navigator.of(context).pop();
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                child: const DashBoard(),
                                type: PageTransitionType.size,
                                alignment: Alignment.bottomRight),
                                (route) => false);
                      },
                      onError: () {
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              title: Text("Error"),
                              content: SizedBox(
                                width: 40,
                                height: 40,
                                child: Text("Error occurred"),
                              ),
                            );
                          },
                        );
                      },);
                  }
                },
                // onCompleted: (){},
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              const Text(
                "Didn't receive OTP Message?",
                textAlign: TextAlign.center,
                textScaleFactor: 1.05,
                style: TextStyle(color: Colors.grey),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.clearGreen,
                ),
                onPressed: () {},
                child: const Text(
                  "RESEND",
                  textScaleFactor: 1.05,
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
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
                        });
                    if (widget.otpScreenData?.screen == 1) {
                      await firebaseAuthMethods
                          .signUpWithEmail(
                              email: widget.otpScreenData!.user.email ??
                                  "test@example.com",
                              password:
                                  widget.otpScreenData!.user.password ?? "",
                              onFailure: () {
                                response("Error", "Error");
                              })
                          .whenComplete(() async {
                        await firebaseAuthMethods.signInWithCred(
                          smsCode: smsCode,
                          authCredential: EmailAuthProvider.credential(
                              email: widget.otpScreenData?.user.email ??
                                  "test@example.com",
                              password:
                                  widget.otpScreenData?.user.password ?? ""),
                          phoneAuthCredential: PhoneAuthProvider.credential(
                            verificationId:
                                widget.otpScreenData!.verificationId,
                            smsCode: smsCode,
                          ),
                          onSuccess: () async {
                            if (!mounted) return;
                            storage.saveUserDetails(widget.otpScreenData!.user);
                            storage
                                .saveUserContacts(widget.otpScreenData!.user);
                            updateInfo();
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageTransition(
                                    child: const DashBoard(),
                                    type: PageTransitionType.size,
                                    alignment: Alignment.bottomRight),
                                (route) => false);
                          },
                          onError: () {
                            if (!mounted) return;
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Error"),
                                  content: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Text("Error occurred"),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      });
                    }
                    if (widget.otpScreenData?.screen == 2) {
                      if (kDebugMode) {
                        print("this is from the sign in page");
                      }
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
