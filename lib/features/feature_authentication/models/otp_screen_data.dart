import 'user_data.dart';

class OtpScreenData {
  final UserData user;
  final String verificationId;
  final int screen;

  const OtpScreenData({required this.user, required this.verificationId, required this.screen });
}