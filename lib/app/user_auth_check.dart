import 'package:agrichapp/features/feature_authentication/providers/auth_provider.dart';
import 'package:agrichapp/features/feature_authentication/screens/auth_screen.dart';
import 'package:agrichapp/features/feature_dashboard/screens/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAuthCheck extends StatelessWidget {
  const UserAuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.userData?.username == null) {
          return const AuthScreen();
        }

        return const DashBoard();
      },
    );
  }
}
