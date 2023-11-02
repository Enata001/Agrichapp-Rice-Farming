import 'package:agrichapp/app/app.dart';
import 'package:agrichapp/app/app_startup.dart';
import 'package:agrichapp/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? firstTime;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const AppStartup(
      child: App(),
    ),
  );
}
